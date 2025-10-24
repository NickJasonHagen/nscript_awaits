# nscript_awaits
usage:
```c++

class test{
    func call(){
        return runwait("neofetch")
    }
    func callback(res){
        print(res)
        print("all done")
    }
}
awaits.async("test.call","test.callback") // <-- class functies


func iets(req){
    return runwait("scanimage -L")
}
func nogiets(req){
    print("blabla ",req,"g")
    return req
}
awaits.async("iets","nogiets","kaas")
```