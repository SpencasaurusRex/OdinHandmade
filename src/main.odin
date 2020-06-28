package main

import "core:fmt"
import "core:sys/win32"

window_callback : win32.Wnd_Proc : proc "std" (window : win32.Hwnd, message: u32, wparam: win32.Wparam, lparam: win32.Lparam) -> win32.Lresult
{
    result : win32.Lresult = 0;

    switch (message)
    {
        case win32.WM_ACTIVATEAPP:
            win32.output_debug_string_a("ACTIVATEAPP");
        
        case win32.WM_SIZE:
            win32.output_debug_string_a("WM_SIZE");
        
        case win32.WM_QUIT:
            win32.output_debug_string_a("WM_QUIT");
        
        case win32.WM_DESTROY:
            win32.output_debug_string_a("WM_DESTROY");
        
        case win32.WM_CLOSE:
            win32.output_debug_string_a("WM_CLOSE");
            result = win32.def_window_proc_a(window, message, wparam, lparam);
        
        case win32.WM_PAINT:
            paint : win32.Paint_Struct;
            device_context := win32.begin_paint(window, &paint);
            x := paint.rc_paint.left;
            y := paint.rc_paint.top;
            w := paint.rc_paint.right - paint.rc_paint.left;
            h := paint.rc_paint.bottom - paint.rc_paint.top;

            win32.pat_blt(device_context, x, y, w, h, win32.WHITENESS);
            win32.end_paint(window, &paint);
        
        case:
            win32.output_debug_string_a("default");
            result = win32.def_window_proc_a(window, message, wparam, lparam);
    }
    return result;
}

main :: proc()
{
    instance : win32.Hinstance = cast(win32.Hinstance)win32.get_module_handle_a(nil);
    class_name : cstring = "WindowClass";
    title : cstring = "Window Title";

    // Setup window class
    windowClass : win32.Wnd_Class_Ex_A;
    {
        windowClass.size = size_of(win32.Wnd_Class_Ex_A);
        windowClass.style = win32.CS_OWNDC | win32.CS_VREDRAW | win32.CS_HREDRAW;
        windowClass.wnd_proc = window_callback;
        windowClass.instance = instance;
        // windowClass.icon = 
        // windowClass.cursor = 
        // windowClass.background = 
        // windowClass.menu_name = 
        windowClass.class_name = class_name;
        // windowClass.sm = 
        
        if win32.register_class_ex_a(&windowClass) == 0
        {
            // TODO: Logging
            return;
        }
    }

    // Create window
    handle : win32.Hwnd;
    {
        ex_style : u32 = 0;
        style : u32 = win32.WS_OVERLAPPEDWINDOW | win32.WS_VISIBLE;
        x, y, w, h : i32 = win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT;
        parent := cast(win32.Hwnd)nil;
        menu := cast(win32.Hmenu)nil;
        lp_param := cast(rawptr)nil;
        handle = win32.create_window_ex_a(0, class_name, title, style, x, y, w, h, parent, menu, instance, lp_param);

        if handle == nil
        {
            // TODO: Logging
            return;
        }
    }

    // Handle message queue
    message : win32.Msg;
    result : win32.Bool;
    for
    {
        result = win32.get_message_a(&message, handle, 0, 0);
        if result
        {
            win32.translate_message(&message);
            win32.dispatch_message_a(&message);
        }
        else do break;
    }
}