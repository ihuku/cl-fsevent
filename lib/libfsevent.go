package main

import (
	"C"
	"fmt"
	"github.com/fsnotify/fsnotify"
)

//export getevent
func getevent(data *C.char) *C.char {
	path := C.GoString(data)
	//fmt.Println("path is => ", path)

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		fmt.Println(err)
	}
	defer watcher.Close()

	err = watcher.Add(path)
	if err != nil {
		fmt.Println(err)
		return C.CString("ERROR")
	}

	select {
	case event, ok := <-watcher.Events:
		if !ok {
			return C.CString("ERROR")
		}
		return C.CString(fmt.Sprintf("OK:%s:%s", event.Name, event.Op))

	case err, ok := <-watcher.Errors:
		if !ok {
			return C.CString("ERROR")
		}
		fmt.Println(err)
		return C.CString("ERROR")
	}

	return C.CString("ERROR")
}

func main() {}
