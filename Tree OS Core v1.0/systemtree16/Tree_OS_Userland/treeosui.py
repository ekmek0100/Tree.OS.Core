#This is a main Tree OS file (ui) dont delete or change below if you are not edit Tree OS. please read license and readme.md
import math
import struct
import subprocess
import pefile
BootStatus = None
class Window: #make a window
	def __init__ (self, title, width, height):
      self.title = title
      self.witdh = width
      self.height = height
	def render(self):   
   	print(f"Drawing window '{self.title}' with size {self.width}x{self.height}")
main_window = Window("")
main_window.render()
main_window = NewWindow("", 800 ,600)
main_window.render()