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


xDir=5
yDir=5
prevDistance = 0.0



currentAngle = 0.0

featureList = []

def recog(event):
	
	global startPos,finalVals, startY, endY, cumulError, rollback, rollingError,function, vertical, vertCounter,distanceLine, countPlace, xDir, yDir,prevDistance, featureList, currentAngle
	
	secX = previous[0] - event.x
	secY = previous[1] - event.y
	prevDistance += sqrt((event.x - previous[0])*(event.x - previous[0]) + (event.y - previous[1])*(event.y - previous[1]))
	tempX = 5
	tempY = 5
	
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
		if prevDistance > 100:
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
