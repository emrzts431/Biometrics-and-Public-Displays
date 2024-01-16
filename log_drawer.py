from kivy.app import App
from kivy.uix.widget import Widget
from kivy.graphics import Color, Ellipse, Line

import sys
import datetime

class LogInput:
    def __init__(self, timestemp, x, y, down, move, up):
        self.timestemp = timestemp
        self.x = x
        self.y = y
        self.down = down
        self.move = move
        self.up = up
    def __str__(self) -> str:
        return "-{0}, {1}, {2}, {3}, {4}, {5}-".format(self.timestemp, self.x, self.y, self.down, self.move, self.up)


if len(sys.argv) != 2:
    print("Usage: python log_drawer.py <filename>.txt")
    exit(-1)
file_name = sys.argv[1]
inputs = []
chunks = []
with open(file_name, "r") as f:
    lines = f.readlines()
    cur_chunk = []
    for line in lines:     
        line_features = line.split(',')
        timestamp = datetime.datetime.fromtimestamp(float(line_features[0]))
        x = int(line_features[1])
        y = int(line_features[2])
        down = int(line_features[3])
        move = int(line_features[4])
        up = int(line_features[5])
        log_input = LogInput(timestamp, x, y, down, move, up)
        if log_input.down == 1:
            cur_chunk = [log_input]
        if log_input.move == 1:
            cur_chunk.append(log_input)
        if log_input.up == 1:
            cur_chunk.append(log_input)
            chunks.append(cur_chunk)


class InputsDrawer(Widget):
    def __init__(self, **kwargs):
        super(InputsDrawer, self).__init__(**kwargs)
        self.bind(pos=self.update_canvas)
        self.bind(size=self.update_canvas)
    def update_canvas(self, *args):
        self.canvas.clear()
        for chunk in chunks:
            line_points = []
            for i in range(len(chunk)):
                if i == 0:
                    self.start_ellipse(chunk[i])
                    line_points.append(chunk[i].x)
                    line_points.append(chunk[i].y)
                elif i == len(chunk) - 1:
                    self.end_ellipse(chunk[i])
                    
                else:
                    # self.line_ellipse(chunk[i])
                    line_points.append(chunk[i].x)
                    line_points.append(chunk[i].y)
            with self.canvas:
                Color(0,1,0)
                Line(points=line_points)
        
    def start_ellipse(self, input_log: LogInput):
        with self.canvas:
            Color(0,1,0)
            d = 15.
            Ellipse(pos=(input_log.x - d /2, input_log.y -d / 2), size= (d, d))
    def end_ellipse(self, input_log: LogInput):
        with self.canvas:
            Color(1,0,0)
            d = 7.
            Ellipse(pos=(input_log.x - d /2, input_log.y -d / 2), size= (d, d))
    def line_ellipse(self, input_log: LogInput):
        with self.canvas:
            Color(0,1,0)
            d = 4.
            Ellipse(pos=(input_log.x - d /2, input_log.y -d / 2), size= (d, d))
class DrawerApp(App):
    def build(self):
        return InputsDrawer()

DrawerApp().run()