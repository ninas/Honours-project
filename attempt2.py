#!/usr/bin/python

from Tkinter import *
from math import sqrt

root = Tk()

root.title("Simple Graph")

root.resizable(0,0)

points = []

spline = 0
startPos = [0.0, 0.0]
previous = [0.0, 0.0]

xy=0.0
n=0.0
x=0.0
y=0.0
x2=0.0
x3=0.0
x2y=0.0
x4=0.0
cumulError=0.0
rollingError=[]
rollback=[]

soFar=[]
cE=0.0
a=0.0
b=0.0
function = lambda val: cE*val*val + b*val + a
vertical = False
vertCounter=0
finalVals=[]
startY=0.0
endY=0.0

lineVals = []
distanceLine=0.0
distances=[]
tag1 = "theline"
def recog(event):
	
	global xy,n,x,y,x2,startPos,finalVals, startY, endY, cumulError, rollback, rollingError,x3,x2y,x4,soFar,cE,a,b,function, vertical, vertCounter,distanceLine
	
	xy+=event.x*event.y
	n+=1.0
	x+=event.x
	y+=event.y
	x2+=event.x*event.x
	x3+=event.x*event.x*event.x
	x2y+=event.x*event.x*event.y
	x4+=event.x*event.x*event.x*event.x
	
	j=x2*n - x*x
	k = x3*n - x*x2
	vertCheck = 0
	bottom = (x4*n-x2*x2)*j - k*k
	if bottom == 0.0:
		print '0 detected 1'
		vertCheck+=1
		bottom = 1e-308
	cE = (x2y*n*j - y*x2*j - n*xy*k + y*x*k)/bottom
	
	bottom = j
	if bottom == 0.0:
		print '0 detected 2'
		bottom = 1e-308
		vertCheck+=1
	b = (n*xy - y*x - cE*k)/bottom
	
	bottom = n
	if bottom == 0.0:
		bottom = 1e-308
	a = (y - b*x - cE*x2)/bottom
	
	
	startY = cE*startPos[0]*startPos[0] + b*startPos[0] + a
	endY = cE*event.x*event.x + b*event.x + a
	
	
	
	
	distanceLine+=sqrt((event.x-previous[0])*(event.x-previous[0]) + (endY-previous[1])*(endY-previous[1]))
		
	
	
	if vertCheck > 0:
		vertical = True
		vertCounter=0
		print 'set to true'
	elif vertCounter < 9 and vertical:
		print 'increementing'
		vertCounter+=1
		rollingError.append(0.0)
	else:
		print 'reseting counter'
		vertical = False
		vertCounter=0
		cumulError += event.y-endY
		rollingError.append(event.y-endY)
	#print a,b,cE
	soFar.append(event)
	
	if len(rollingError) > 5:
		cumulError-=rollingError[0]
		rollingError.pop(0)
	previous[0] = event.x
	previous[1]= endY
	
	if not vertical and abs(cumulError/len(rollingError)) > 15.0:
		print 'error:',(cumulError/len(rollingError))
		
		print 'Values: ',a,b,cE
		finalVals.extend([startPos[0], startY,event.x,endY])
		lineVals.append([a,b,cE, startPos[0],startY, event.x, endY])
		distances.append(distanceLine)
		distanceLine=0.0
		for i in soFar:
			newY = function(i.x)
			c.create_oval(i.x, newY, i.x+5, newY+5, fill="green")
		
		soFar = []
		startPos[0] = event.x
		startPos[1]= event.y
		
		xy=event.x*event.y
		n=1.0
		x=event.x
		y=event.y
		x2=event.x*event.x
		x3=x2*x
		x2y=x2*y
		x4=x3*x
		cumulError=0.0
		second = rollback[:]
		rollback=[]
		
		rollingError=[]
		print 'RESET'
	"""elif len(rollback)!=0:
		rollback=[]
	 """
	


def start(event):
	global xy,n,x,y,x2,startPos,previous, cumulError, finalVals,x3,x2y,x4, lineVals, vertical, vertCounter,distanceLine, distances
	distances=[]
	finalVals=[]
	distanceLine=0.0
	lineVals=[]
	vertical=False
	vertCounter=0
	c.delete('all')
	c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="black")
	startPos[0] = event.x
	startPos[1]= event.y
	previous[0] = event.x
	previous[1]= event.y
	
	xy=event.x*event.y
	n=1.0
	x=event.x
	y=event.y
	x2=event.x*event.x
	x3=x2*x
	x2y=x2*y
	x4=x3*x
	cumulError=0.0
	
def end(event):
	global soFar,cE,a,b,function
	point(event)
	#c.create_line(startPos[0], startY, event.x, endY)
	for i in soFar:
			newY = function(i.x)
			c.create_oval(i.x, newY, i.x+5, newY+5, fill="green")
	soFar = []
	finalVals.extend([startPos[0], startY,event.x,endY])
	lineVals.append([a,b,cE, startPos[0],startY, event.x, endY])
	distances.append(distanceLine)
	
def point(event):
	global previous
	distance = sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	#print distance,(event.x - previous[0]),(event.y - previous[1]), event.x, previous[0], event.y, previous[1]
	if distance > 0.0:
		c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="black")
		points.append(event.x)
		points.append(event.y)
		previous[0] = event.x
		previous[1]= event.y
		recog(event)
	return points

def canxy(event):
	print event.x, event.y

def graph(event):
	print lineVals
	
	
	print distances
	"""newVals=[]
	gradients=[]
	for i in range(len(finalVals)/2):
		#c.create_oval(finalVals[i*2], finalVals[i*2+1], finalVals[i*2]+5, finalVals[i*2+1]+5, fill="red")
		if i%2 != 0:
			#print i,i*2,i*2-2,i*2+1,i*2-1
			distance = sqrt((finalVals[i*2] - finalVals[i*2-2])*(finalVals[i*2] - finalVals[i*2-2]) + (finalVals[i*2+1] - finalVals[i*2-1])*(finalVals[i*2+1] - finalVals[i*2-1]))
			#print 'Distance: ',distance
			bottom = (finalVals[i*2] - finalVals[i*2-2])
			if bottom == 0:
				bottom = 0.0000000001
			gradient = (finalVals[i*2+1] - finalVals[i*2-1])/bottom
			#print 'Gradient: ',gradient
			#print newVals,gradients
			if distance >20.0:
				if len(newVals)!=0 and abs(gradient - gradients[len(gradients)-1]) <0.5:
					newVals[len(newVals)-1] = finalVals[i*2+1]
					newVals[len(newVals)-2] = finalVals[i*2]
				else:
					newVals.extend([finalVals[i*2-2], finalVals[i*2-1],finalVals[i*2], finalVals[i*2+1]])
					gradients.append(gradient)
	for i in range(len(newVals)/4):
		
			c.create_line(newVals[i*4], newVals[i*4+1], newVals[i*4+2], newVals[i*4+3], fill="red") """
	
	
			
	

def toggle(event):
	#print finalVals
	for i in range(len(finalVals)/2):
		c.create_oval(finalVals[i*2], finalVals[i*2+1], finalVals[i*2]+5, finalVals[i*2+1]+5, fill="red")
		if i%2 != 0:
			#print i,i*2,i*2-2,i*2+1,i*2-1

			#print 'Distance: ',sqrt((finalVals[i*2] - finalVals[i*2-2])*(finalVals[i*2] - finalVals[i*2-2]) + (finalVals[i*2+1] - finalVals[i*2-1])*(finalVals[i*2+1] - finalVals[i*2-1]))
			bottom = (finalVals[i*2] - finalVals[i*2-2])
			if bottom == 0:
				bottom = 0.0000000001
			#print 'Gradient: ',(finalVals[i*2+1] - finalVals[i*2-1])/bottom

c = Canvas(root, bg="white", width=600, height= 600)

c.configure(cursor="crosshair")

c.pack()

c.bind("<Button-1>", start)
c.bind("<B1-Motion>", point)
c.bind("<ButtonRelease-1>", end)


c.bind("<Button-3>", graph)

c.bind("<Button-2>", toggle)

root.mainloop()
