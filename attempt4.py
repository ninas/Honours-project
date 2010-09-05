#!/usr/bin/python
"""
	Home brewed feature extraction
	Nina Schiff
"""

from Tkinter import *
from math import sqrt, tan, degrees

root = Tk()

root.title("Simple Graph")

root.resizable(0,0)


startPos = [0.0, 0.0]
previous = [0.0, 0.0]
sumSquares = 0.0
degFreedom = 0.0

xDir=5
yDir=5
prevDistance = 0.0

x=0.0
x2=0.0

currentAngle = 0.0

featureList = []

def recog(event):
	
	global startPos, xDir, yDir,prevDistance, featureList, currentAngle, sumSquares, degFreedom,x,x2
	
	secX = previous[0] - event.x
	secY = previous[1] - event.y
	prevDistance += sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	tempX = 5
	tempY = 5
	degFreedom+=1
	x+=event.x
	x2+=event.x*event.x
	
	if secX > 2:
		tempX = 1
	elif secX < -2:
		tempX = -1
	else:
		tempX = 0
		
	if secY > 2:
		tempY = 1
	elif secY < -2:
		tempY = -1
	else:
		tempY = 0
	
	
	
	
	
	
	if not (xDir == tempX and yDir == tempY):
		"""print 'Sum squares =',x2 - 2*x*(x/degFreedom)+(x/degFreedom)*(x/degFreedom)
		print 'Normalised sum squares =',(x2 - 2*x*(x/degFreedom)+(x/degFreedom)*(x/degFreedom))/float(degFreedom-1.0)
		x=event.x
		x2=event.x*event.x
		degFreedom=1.0"""
		
		if prevDistance > 100:
			chordLength = sqrt((event.x - startPos[0])*(event.x - startPos[0]) + (event.y - startPos[1])*(event.y - startPos[1])) 
			print 'Chord length: ',chordLength, 'Arc length: ',prevDistance
			print 'Curvature: ',sqrt(24*(prevDistance - chordLength)/(chordLength*chordLength*chordLength))
		
			tempAngle = degrees(tan((startPos[1] - event.y)/float(startPos[0] - event.x)))
			if abs(currentAngle - tempAngle) > 10:
				featureList.append([startPos[0], startPos[1], event.x, event.y])
				
			elif len(featureList) > 0:
				featureList[len(featureList)-1][2] = event.x
				featureList[len(featureList)-1][3] = event.y
				print 'Joined'
			else:
				featureList.append([startPos[0], startPos[1], event.x, event.y])
			c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="green")
			print 'X: ',event.x,'Y: ',event.y, 'PrevX: ',previous[0],'PrevY: ',previous[1]
			print 'X: ',tempX,'Y: ',tempY,'xDir: ',xDir,'yDir: ',yDir
			prevDistance=0.0
			
			currentAngle = tempAngle
			xDir = tempX
			yDir = tempY
			startPos[0] = event.x
			startPos[1]= event.y
		else:
			print 'Didn\'t break'
			xDir = tempX
			yDir = tempY
	
	previous[0] = event.x
	previous[1]= event.y
	
	
	
	
		
	


def start(event):
	global startPos,previous, prevDistance, featureList, currentAngle
		
	c.delete('all')
	c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="black")
	startPos[0] = event.x
	startPos[1]= event.y
	previous[0] = event.x
	previous[1]= event.y
	prevDistance = 0.0
	featureList=[]
	currentAngle=0.0
	
	
def end(event):
	global soFar,cE,a,b,function, startPos, currentAngle, featureList, prevDistance
	chordLength = sqrt((event.x - startPos[0])*(event.x - startPos[0]) + (event.y - startPos[1])*(event.y - startPos[1])) 
	print 'Chord length: ',chordLength, 'Arc length: ',prevDistance
	print 'Curvature: ',sqrt(24*(prevDistance - chordLength)/(chordLength*chordLength*chordLength))
			
	tempAngle = degrees(tan((startPos[1] - event.y)/float(startPos[0] - event.x)))
	if abs(currentAngle - tempAngle) > 10:
		featureList.append([startPos[0], startPos[1], event.x, event.y])
		
	elif len(featureList) > 0:
		featureList[len(featureList)-1][2] = event.x
		featureList[len(featureList)-1][3] = event.y
		print 'Joined'
	else:
		featureList.append([startPos[0], startPos[1], event.x, event.y])
	c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="green")
	print '____________________________________________________________________________________'
	
	
	
	
	
def point(event):
	global previous
	distance = sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	
	if distance > 10.0:
		c.create_oval(event.x, event.y, event.x+5, event.y+5, fill="black")
		
		
		recog(event)
	


def graph(event):
	global featureList
	
	for i in featureList:
		c.create_line(i[0], i[1], i[2], i[3], fill="red")
		
			


c = Canvas(root, bg="white", width=600, height= 600)

c.configure(cursor="crosshair")

c.pack()

c.bind("<Button-1>", start)
c.bind("<B1-Motion>", point)
c.bind("<ButtonRelease-1>", end)


c.bind("<Button-3>", graph)



root.mainloop()
