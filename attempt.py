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
cumulError=0.0
rollingError=[]
rollback=[]

finalVals=[]
startY=0.0
endY=0.0

tag1 = "theline"
def recog(event):
	
	global xy,n,x,y,x2,startPos,finalVals, startY, endY, cumulError, rollback, rollingError
	
	xy+=event.x*event.y
	n+=1.0
	x+=event.x
	y+=event.y
	x2+=event.x*event.x
	bottom = (x2 - 1/n*x*x)
	if bottom == 0.0:
		bottom = 0.000000001
	b = (xy - 1/n*x*y)/bottom
	a = y/n - b*x/n
	
	startY = b*startPos[0] + a
	endY = b*event.x + a
	print b
	
	cumulError += event.y-endY
	rollingError.append(event.y-endY)
	if len(rollingError) > 5:
		cumulError-=rollingError[0]
		rollingError.pop(0)
	print 'error:',(cumulError/len(rollingError))
	if abs(cumulError/len(rollingError)) > 8.0:
		"""if len(rollback) <4:
			rollback.append((event, startY, startPos[0], endY))
			return
		
		finalVals.extend([rollback[0][2], rollback[0][1],rollback[0][0].x,rollback[0][3]])
		c.create_line([rollback[0][2], rollback[0][1],rollback[0][0].x,rollback[0][3]])
		"""
		finalVals.extend([startPos[0], startY,event.x,endY])
		c.create_line([startPos[0], startY,event.x,endY])
		startPos[0] = event.x
		startPos[1]= event.y
		previous[0] = event.x
		previous[1]= event.y
		xy=event.x*event.y
		n=1.0
		x=event.x
		y=event.y
		x2=event.x*event.x
		cumulError=0.0
		rollback=[]
		rollingError=[]
		print 'RESET'
	"""elif len(rollback)!=0:
		rollback=[]
	 """
	


def start(event):
	global xy,n,x,y,x2,startPos,previous, cumulError, finalVals
	finalVals=[]
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
	cumulError=0.0
	
def end(event):
	point(event)
	c.create_line(startPos[0], startY, event.x, endY)
	finalVals.extend([startPos[0], startY,event.x,endY])
	
def point(event):
	global previous
	distance = sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	#print distance,(event.x - previous[0]),(event.y - previous[1]), event.x, previous[0], event.y, previous[1]
	if distance > 10.0:
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
	newVals=[]
	gradients=[]
	for i in range(len(finalVals)/2):
		#c.create_oval(finalVals[i*2], finalVals[i*2+1], finalVals[i*2]+5, finalVals[i*2+1]+5, fill="red")
		if i%2 != 0:
			print i,i*2,i*2-2,i*2+1,i*2-1
			distance = sqrt((finalVals[i*2] - finalVals[i*2-2])*(finalVals[i*2] - finalVals[i*2-2]) + (finalVals[i*2+1] - finalVals[i*2-1])*(finalVals[i*2+1] - finalVals[i*2-1]))
			print 'Distance: ',distance
			bottom = (finalVals[i*2] - finalVals[i*2-2])
			if bottom == 0:
				bottom = 0.0000000001
			gradient = (finalVals[i*2+1] - finalVals[i*2-1])/bottom
			print 'Gradient: ',gradient
			print newVals,gradients
			if distance >20.0:
				if len(newVals)!=0 and abs(gradient - gradients[len(gradients)-1]) <0.5:
					newVals[len(newVals)-1] = finalVals[i*2+1]
					newVals[len(newVals)-2] = finalVals[i*2]
				else:
					newVals.extend([finalVals[i*2-2], finalVals[i*2-1],finalVals[i*2], finalVals[i*2+1]])
					gradients.append(gradient)
	for i in range(len(newVals)/4):
		
			c.create_line(newVals[i*4], newVals[i*4+1], newVals[i*4+2], newVals[i*4+3], fill="red")
			
	

def toggle(event):
	print finalVals
	for i in range(len(finalVals)/2):
		c.create_oval(finalVals[i*2], finalVals[i*2+1], finalVals[i*2]+5, finalVals[i*2+1]+5, fill="red")
		if i%2 != 0:
			print i,i*2,i*2-2,i*2+1,i*2-1
			print 'Distance: ',sqrt((finalVals[i*2] - finalVals[i*2-2])*(finalVals[i*2] - finalVals[i*2-2]) + (finalVals[i*2+1] - finalVals[i*2-1])*(finalVals[i*2+1] - finalVals[i*2-1]))
			bottom = (finalVals[i*2] - finalVals[i*2-2])
			if bottom == 0:
				bottom = 0.0000000001
			print 'Gradient: ',(finalVals[i*2+1] - finalVals[i*2-1])/bottom

c = Canvas(root, bg="white", width=600, height= 600)

c.configure(cursor="crosshair")

c.pack()

c.bind("<Button-1>", start)
c.bind("<B1-Motion>", point)
c.bind("<ButtonRelease-1>", end)


c.bind("<Button-3>", graph)

c.bind("<Button-2>", toggle)

root.mainloop()
