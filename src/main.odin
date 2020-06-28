package main

import "core:fmt"
import "core:sys/win32"

window_callback : win32.Wnd_Proc : proc "std" (window : win32.Hwnd, message: u32, wparam: win32.Wparam, lparam: win32.Lparam) -> win32.Lresult
{
    result : win32.Lresult = 0;

    // switch (message)
    // {
    //     case win32.WM_ACTIVATEAPP:
    //         win32.output_debug_string_a("ACTIVATEAPP");
    //     case win32.WM_SIZE:
    //         win32.output_debug_string_a("WM_SIZE");
    //     case win32.WM_QUIT:
    //         win32.output_debug_string_a("WM_QUIT");
    //     case win32.WM_DESTROY:
    //         win32.output_debug_string_a("WM_DESTROY");
    //     case win32.WM_CLOSE:
    //         win32.output_debug_string_a("WM_CLOSE");
    //     case:
    //         win32.output_debug_string_a("default");
    //         result = win32.def_window_proc_a(window, message, wparam, lparam);
    // }
    result = win32.def_window_proc_a(window, message, wparam, lparam);

    return result;
}

main :: proc()
{
    handle : win32.Hinstance = cast(win32.Hinstance)win32.get_module_handle_a(nil);
    class_name : cstring = "WindowClass";
    title : cstring = "Window Title";

    // Setup window class
    windowClass : win32.Wnd_Class_Ex_A;
    {
        windowClass.size = size_of(win32.Wnd_Class_Ex_A);
        windowClass.style = win32.CS_OWNDC | win32.CS_VREDRAW | win32.CS_HREDRAW;
        windowClass.wnd_proc = window_callback;
        windowClass.instance = handle;
        // windowClass.icon = 
        // windowClass.cursor = 
        // windowClass.background = 
        // windowClass.menu_name = 
        windowClass.class_name = class_name;
        // windowClass.sm = 
        
        win32.register_class_ex_a(&windowClass);
    }

    // Create window
    {
        ex_style : u32 = 0;
        style : u32 = win32.WS_VISIBLE;
        x, y, w, h : i32 = win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT;
        parent := cast(win32.Hwnd)nil;
        menu := cast(win32.Hmenu)nil;
        lp_param := cast(rawptr)nil;
        win32.create_window_ex_a(0, class_name, title, style, x, y, w, h, parent, menu, handle, lp_param);
        fmt.printf("Testing");    
    }
}