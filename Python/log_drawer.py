from kivy.app import App
from kivy.uix.widget import Widget
from kivy.graphics import Color, Ellipse, Line
import sys
import datetime
from kivy.utils import platform


class LogInput:
    def __init__(self, timestemp, x, y, id, down, move, up):
        self.timestemp = timestemp
        self.x = x
        self.y = y
        self.id = id
        self.down = down
        self.move = move
        self.up = up
    def __str__(self) -> str:
        return "-{0}, {1}, {2}, {3}, {4}, {5}, {6}-".format(self.timestemp, self.x, self.y, self.id, self.down, self.move, self.up)


if len(sys.argv) != 2:
    print("Usage: python log_drawer.py <filename>.txt")
    exit(-1)

file_name = sys.argv[1]
inputs = dict()
chunks = []
with open(file_name, "r") as f:
    lines = f.readlines()
    cur_chunk = []
    first = True
    for line in lines:
        if first:
            first = False
            continue   
        line_features = line.split(',')
        timestamp = datetime.datetime.fromtimestamp(float(line_features[0]))
        x = int(line_features[1])
        y = int(line_features[2])
        id = int(line_features[3])
        down = int(line_features[4])
        move = int(line_features[5])
        up = int(line_features[6])
        log_input = LogInput(timestamp, x, y, id, down, move, up)
        if inputs.get(log_input.id) is not None:
            inputs[log_input.id].append(log_input)
        else:
            inputs[log_input.id] = [log_input]

    for input_chunk in inputs.values():
        chunks.append(input_chunk)
            


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
        print(platform)
        return InputsDrawer()

DrawerApp().run()