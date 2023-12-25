from kivy.app import App
from kivy.uix.widget import Widget
import datetime
from kivy.graphics import Color, Ellipse, Line
import random
import os

CLICK_DOWN = "1,0,0\n"
CLICK_UP = "0,0,1\n"
MOVE = "0,1,0\n"

folder_path = os.curdir

active_touches = []
touched = False
now = datetime.datetime.now().__str__().replace(' ', '')
now = now.replace(':', '_')
print(now)
class TouchInput(Widget):
    
    def getNowString(self, now : datetime.datetime):
        #return "{}-{}-{} {}:{}:{}:{}".format(now.day, now.month, now.year, now.hour, now.minute, now.second, now.microsecond)
        return str(datetime.datetime.now().timestamp())

    def logPosition(self, coordinates_tuple, id, uid, type):
        #with open("TouchLogs{}_{}.txt".format(now, id), "a") as f:
        with open("TouchLogs{}.txt".format(now), "a") as f:
                log = self.getNowString(datetime.datetime.now()) +f',{int(coordinates_tuple[0])},{int(coordinates_tuple[1])},{id},{uid},' + type
                f.write(log)

    def on_touch_down(self, touch):
        print('PRESSED')
        # global touched
        # touched = True
        active_touches.append(touch.id)
        print(touch.profile)
        print(touch)
        print(touch.device)
        
        if touch.device == 'wm_touch':
            self.logPosition(touch.pos, touch.id, touch.uid, CLICK_DOWN)
        else:
            self.logPosition(touch.pos, -1, -1, CLICK_DOWN)

            pass
        with self.canvas:
            Color(0,1,0)            
            d = 15.
            Ellipse(pos=(touch.x - d /2, touch.y -d / 2), size= (d, d))
            touch.ud['line'] = Line(points=(touch.x, touch.y))

    def on_touch_move(self, touch):
        print('MOVE')
        
        # global touched
        # if touched:
        try:
            if touch.id in active_touches:
                if touch.device == 'wm_touch':
                    self.logPosition(touch.pos, touch.id, touch.uid, MOVE)
                else:
                    self.logPosition(touch.pos, -1, -1, MOVE)
            #print(touch)
            touch.ud['line'].points += [touch.x, touch.y]
        except:
            print("Permission problem")

    def on_touch_up(self, touch):
        print('RELEASED')
        # global touched
        # touched = False
        active_touches.remove(touch.id)
        if touch.device == 'wm_touch':
            self.logPosition(touch.pos, touch.id, touch.uid, CLICK_UP)
        else:
            self.logPosition(touch.pos, -1, -1, CLICK_UP)
            
        #print(touch)
        with self.canvas:
            Color(1,0,0)
            d= 7.
            Ellipse(pos=(touch.x - d /2, touch.y -d / 2), size= (d, d))

class InputLogger(App):
    def build(self):
        return TouchInput()
    
    #region Maybe usefull code
    # def on_stop(self):
    #     files = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f)) and f.lower().endswith('txt')]

    #     with open('TouchLogs_{}.txt'.format(now), 'w') as f:
    #         for file in files:
    #             with open(file, 'r') as f_i:
    #                 f.writelines(f_i.readlines())
    #             os.remove(file)
    #endregion

if __name__ == '__main__':
    InputLogger().run()
