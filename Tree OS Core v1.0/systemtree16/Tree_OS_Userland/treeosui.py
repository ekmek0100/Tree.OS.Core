#This is a main Tree OS file (ui) dont delete or change below if you are not edit Tree OS. please read license and readme.md
import math
import struct
import subprocess
import pygame
BootStatus = None
class Window: #this line to 18th line is a shortcut to generate window
    def __init__(self, title, width, height, content):
      self.title = title
      self.width = width
      self.height = height
    def render(self):
        print(f"Drawing window '{self.title}' with size {self.width}x{self.height}")
        print(f"Content: {self.content}")
        print("-" * 20)
def NewWindow(title, width, height, content=""):
   return Window(title, width, height, content)
#end of shortcut code
#how to use this shortcut: win1 = NewWindow("*window name*, *size(width)*, *size(height)*, "*content*")
class WindowManager:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((800, 600))
        self.windows = []
        
    def spawn(self, title, width, height, content=""):
        new_win = Window(title, width, height, content)
        self.windows.append(new_win)
        return new_win
    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            self.screen.fill((30, 30, 30))
            for win in self.windows:
                pass
                
            pygame.display.flip()
        pygame.quit() 
#end of shortcut code 
win1 = NewWindow("amogus", 800, 600, "welcome")