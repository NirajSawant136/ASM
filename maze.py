'''
This is a Maze Generator made in python using pygame module.
I have used Randomized Prim's Algorithm in this code.
A really fun project!
'''

import pygame
import time
import random

WIDTH = 1200
HEIGHT = 700
fps = 30

WHITE = (255,255,255)
RED = (255 , 38 , 38)

pygame.init()
pygame.mixer.init()
MAZE = pygame.display.set_mode((WIDTH , HEIGHT))
clock = pygame.time.Clock()

global width , height

width , height = 75 , 45

marked = []
visited = []

def buildMaze():
	x , y = random.randint(0,width-1) , random.randint(0, height-1)
	marked.append((x , y))
	pygame.draw.rect(MAZE , WHITE , (x*15,y*15,15,15),0)
	pygame.display.update()
	visited = addNeighbors(x,y)

	while len(visited) != 0:
		time.sleep(0.1)
		(x , y) = random.choice(visited)
		pygame.draw.rect(MAZE , WHITE , (x*15,y*15,15,15),0)
		pygame.display.update()
		visited.remove((x , y))
		marked.append((x , y))
		visited = addNeighbors(x , y)
		removeWall(x , y)

def addNeighbors(x,y):
	if not (x-2,y) in marked and not (x-2,y) in visited and x-2 > 0:
		visited.append((x-2 , y))
		pygame.draw.rect(MAZE , RED , ((x-2)*15,y*15,15,15),0)
		pygame.display.update()

	if not (x+2,y) in marked and not (x+2,y) in visited and x+2 < width:
		visited.append((x+2,y))
		pygame.draw.rect(MAZE , RED , ((x+2)*15,y*15,15,15),0)
		pygame.display.update()

	if not (x,y-2) in marked and not (x,y-2) in visited and y-2 > 0:
		visited.append((x,y-2))
		pygame.draw.rect(MAZE , RED , (x*15,(y-2)*15,15,15),0)
		pygame.display.update()

	if not (x,y+2) in marked and not (x,y+2) in visited and y+2 < height:
		visited.append((x,y+2))
		pygame.draw.rect(MAZE , RED , (x*15,(y+2)*15,15,15),0)
		pygame.display.update()

	return visited

def removeWall(x , y):
	randList = []
	if (x-2,y) in marked:
		randList.append((x-1,y))
	
	if (x+2,y) in marked:
		randList.append((x+1,y))

	if (x,y-2) in marked:
		randList.append((x,y-1))

	if (x,y+2) in marked:
		randList.append((x,y+1))

	if len(randList) != 0:
		(x,y) = random.choice(randList)
		pygame.draw.rect(MAZE , WHITE , (x*15,y*15,15,15),0)
		pygame.display.update()

	return


buildMaze()

run = True
while run:
	clock.tick(fps)
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			pygame.quit()
			run = False

		if event.type == ord('q'):
			pygame.quit()
run = False