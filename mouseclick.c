//http://groups.google.de/groups?hl=de&lr=&threadm=1992May27.141519.246452%40cs.cmu.edu&rnum=2&prev=/groups%3Fhl%3Dde%26lr%3D%26q%3DXSendEvent%2BButtonPress%26btnG%3DSuche

#include <stdlib.h>
#include <X11/Xlib.h>


int main() {
    XEvent event;
    Display *display = XOpenDisplay(getenv("DISPLAY"));

    bzero(&event,sizeof(XEvent));
    event.type = ButtonPress;
    event.xbutton.button = Button1;
    event.xbutton.same_screen = True;

    /* get info about current pointer position */
    XQueryPointer(display, RootWindow(display, DefaultScreen(display)),
                  &event.xbutton.root, &event.xbutton.window,
                  &event.xbutton.x_root, &event.xbutton.y_root,
                  &event.xbutton.x, &event.xbutton.y,
                  &event.xbutton.state);

    event.xbutton.subwindow = event.xbutton.window;

    /* walk down through window hierachy to find youngest child */
    while (event.xbutton.subwindow) {
        event.xbutton.window = event.xbutton.subwindow;
        XQueryPointer(display, event.xbutton.window,
                      &event.xbutton.root, &event.xbutton.subwindow,
                      &event.xbutton.x_root, &event.xbutton.y_root,
                      &event.xbutton.x, &event.xbutton.y,
                      &event.xbutton.state);
    }

    /* send ButtonPress event to youngest child */
    if (XSendEvent(display, PointerWindow, True, 0xfff, &event) == 0)
        printf("XSendEvent Failed\n");
    XFlush(display);

    /* sleep for a little while */
    usleep(100000);

    /* set up ButtonRelease event */
    event.type = ButtonRelease;
    event.xbutton.state = 0x100;

    /* send ButtonRelease event to youngest child */
    if (XSendEvent(display, PointerWindow, True, 0xfff, &event) == 0)
        printf("XSendEvent Failed\n");
    XFlush(display);

}
