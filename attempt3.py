#!/usr/bin/python
"""
	Circle fitting using least squares
	Nina Schiff
"""

from Tkinter import *
from math import sqrt

root = Tk()

root.title("Simple Graph")

root.resizable(0,0)

points = []

spline = 0
startPos = [0.0, 0.0]
previous = [0.0, 0.0]

countPlace = 0

xy=0.0
n=0.0
x=0.0
y=0.0
x2=0.0
x3=0.0
x2y=0.0
x4=0.0
y2=0.0
y3=0.0
xy2=0.0

cumulError=0.0
rollingError=[]
rollback=[]

soFar=[]
cE=0.0
a=0.0
b=0.0
function = lambda val: cE - (val - a)*(val - a)
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
	
	global xy,n,x,y,x2,startPos,finalVals, startY, endY, cumulError, rollback, rollingError,x3,x2y,x4,soFar,cE,a,b,function, vertical, vertCounter,distanceLine, y2,y3,xy2, countPlace
	print event.x,event.y
	xy+=event.x*event.y
	n+=1.0
	x+=event.x
	y+=event.y
	x2+=event.x*event.x
	x3+=event.x*event.x*event.x
	x2y+=event.x*event.x*event.y
	x4+=event.x*event.x*event.x*event.x
	y2 += event.y*event.y
	y3 += event.y*event.y*event.y
	xy2 += event.x*event.y*event.y
	
	xBar = x/float(n)
	yBar = y/float(n)
	
	Suu = x2 - 2*x*xBar + xBar*xBar*n
	Svv = y2 - 2*y*yBar + yBar*yBar*n
	Suv = xy - x*yBar - y*xBar +n*xBar*yBar
	#print 'Suu',Suu,'Svv',Svv,'Suv',Suv
	
	Suuu = x3 - 3*x2*xBar + 3*x*xBar*xBar - xBar*xBar*xBar*n
	Svvv = y3 - 3*y2*yBar + 3*y*yBar*yBar - yBar*yBar*yBar*n
	Suvv = xy2 - 2*xy*yBar + x*yBar*yBar - xBar*y2 + 2*yBar*y*xBar - xBar*yBar*yBar*n
	Svuu = x2y - 2*xy*xBar + y*xBar*xBar - x2*yBar + 2*yBar*x*xBar - yBar*xBar*xBar*n
	print 'Bottom',2.0*(Svv*Suu - Suv*Suv)
	bottom = 2.0*(Svv*Suu - Suv*Suv)
	if 2.0*(Svv*Suu - Suv*Suv) == 0:
		bottom = 0.00000000000000000000001
	vc = (Svvv*Suu + Svuu*Suu - Suv*Suuu - Suv*Suvv)/bottom
	
	bottom = (2.0*Suu)
	if bottom == 0:
		bottom = 0.00000000000000000000001
	uc = (Suuu + Suvv - 2*vc*Suv)/bottom
	
	
	cE = uc*uc + vc*vc + (Suu+Svv)/n
	 
	a = uc + xBar
	b = vc + yBar
	#c.create_oval(a, b, a+15, b+15, fill="red")
	print 'math.sqrt(',cE,'-(',event.x,'-',a,')*(',event.x,'-',a,'))+',b
	
	endY = function(event.x)
	
	countPlace+=1
	soFar.append(event)
	
	if endY < 0:
		return
	multiplier = 1;
	if event.y < b:
		print 'setting -1'
		multiplier=-1;
	#startY = function(startPos[0])
	endY = multiplier*sqrt(endY) + b
	print 'Y: ',event.y,'New y:',endY
	
	
	distanceLine+=sqrt((event.x-previous[0])*(event.x-previous[0]) + (endY-previous[1])*(endY-previous[1]))
		
	
	
	
	cumulError += event.y-endY
	rollingError.append(event.y-endY)
	#print a,b,cE
	soFar.append(event)
	
	if len(rollingError) > 5:
		cumulError-=rollingError[0]
		rollingError.pop(0)
	previous[0] = event.x
	previous[1]= endY
	
	print 'error:',(cumulError/len(rollingError))
	
	
	if abs(cumulError/len(rollingError)) > 15.0:
		print 'error:',(cumulError/len(rollingError))
		
		print 'Values: ',a,b,cE
		finalVals.extend([startPos[0], startY,event.x,endY])
		lineVals.append([a,b,cE, startPos[0],startY, event.x, endY])
		distances.append(distanceLine)
		distanceLine=0.0
		for i in soFar:
			newY = function(i.x)
			if newY < 0:
				print 'continueing'
				continue
			multiplier = 1;
			if i.y  <  b:
				multiplier=-1;
				print 'setting -1'
			newY=multiplier*sqrt(newY)+b
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
		y2=y*y
		y3=y2*y
		xy2=xy*y
		
		for i in soFar[-5:]:
			xy+=i.x*i.y
			n+=1.0
			x+=i.x
			y+=i.y
			x2+=i.x*i.x
			x3+=i.x*i.x*i.x
			x2y+=i.x*i.x*i.y
			x4+=i.x*i.x*i.x*i.x
			y2+=i.y*i.y
			y3+=i.y*i.y*i.y
			xy2+=i.x*i.y*i.y
		cumulError=0.0
		second = rollback[:]
		rollback=[]
		
		rollingError=[]
		print 'RESET'
		
	


def start(event):
	global xy,n,x,y,x2,startPos,previous, cumulError, finalVals,x3,x2y,x4,y2,y3,xy2, lineVals, vertical, vertCounter,distanceLine, distances, soFar
	#event.x  = 0.0
	#event.y=0.0
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
	soFar=[]
	xy=event.x*event.y
	n=1.0
	x=event.x
	y=event.y
	x2=event.x*event.x
	x3=x2*x
	x2y=x2*y
	x4=x3*x
	y2=y*y
	y3=y2*y
	xy2=xy*y
	cumulError=0.0
	recog(event)
	
	xs = [0.5,1,1.5,2,2.5,3]
	ys= [0.25,1,2.25,4,6.25,9]
	
	"""for i in range(len(xs)):
		event.x = xs[i]
		event.y= ys[i]
		c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="black")
		points.append(event.x)
		points.append(event.y)
		previous[0] = event.x
		previous[1]= event.y
		recog(event)"""
	
def end(event):
	global soFar,cE,a,b,function, startPos
	point(event)
	#c.create_line(startPos[0], startY, event.x, endY)
	coords=[]
	for i in soFar:
			newY = function(i.x)
			if newY < 0:
				print 'continueing'
				continue
			multiplier = 1;
			if i.y  <  b:
				multiplier=-1;
				print 'setting -1'
			newY=multiplier*sqrt(newY)+b
			c.create_oval(i.x, newY, i.x+5, newY+5, fill="green")
	
	soFar = []
	finalVals.extend([startPos[0], startY,event.x,endY])
	lineVals.append([a,b,cE, startPos[0],startY, event.x, endY])
	distances.append(distanceLine)
	
def point(event):
	global previous
	distance = sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	#print distance,(event.x - previous[0]),(event.y - previous[1]), event.x, previous[0], event.y, previous[1]
	if distance != 0.0:
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
