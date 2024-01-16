from kivy.app import App
from kivy.uix.widget import Widget
import datetime
from kivy.graphics import Color, Ellipse, Line
import random

CLICK_DOWN = "1,0,0\n"
CLICK_UP = "0,0,1\n"
MOVE = "0,1,0\n"

touched = False
now = datetime.datetime.now().__str__().replace(' ', '')
now = now.replace(':', '_')
print(now)
class TouchInput(Widget):
    
    def getNowString(self, now : datetime.datetime):
        #return "{}-{}-{} {}:{}:{}:{}".format(now.day, now.month, now.year, now.hour, now.minute, now.second, now.microsecond)
        return str(datetime.datetime.now().timestamp())

    def logPosition(self, coordinates_tuple, type):
        with open("TouchLogs{}.txt".format(now), "a") as f:
                log = self.getNowString(datetime.datetime.now()) +f',{int(coordinates_tuple[0])},{int(coordinates_tuple[1])},' + type
                f.write(log)

    def on_touch_down(self, touch):
        print('PRESSED')
        global touched
        touched = True
        print(touch.profile)
        self.logPosition(touch.pos, CLICK_DOWN)
        with self.canvas:
            Color(0,1,0)            
            d = 15.
            Ellipse(pos=(touch.x - d /2, touch.y -d / 2), size= (d, d))
            touch.ud['line'] = Line(points=(touch.x, touch.y))

    def on_touch_move(self, touch):
        print('MOVE')
        global touched
        if touched:
            self.logPosition(touch.pos, MOVE)
        touch.ud['line'].points += [touch.x, touch.y]

    def on_touch_up(self, touch):
        print('RELEASED')
        global touched
        touched = False
        self.logPosition(touch.pos, CLICK_UP)
        with self.canvas:
            Color(1,0,0)
            d= 7.
            Ellipse(pos=(touch.x - d /2, touch.y -d / 2), size= (d, d))

class InputLogger(App):
    def build(self):
        return TouchInput()

if __name__ == '__main__':
    InputLogger().run()
