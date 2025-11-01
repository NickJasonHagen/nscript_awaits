thread awaits{
    func threadreceive(rec){
        if rec == "exit"{
            if $ready = true {
                break "coroutine_thread"
            }
        }
        return $ready
    }
    // create a string with the full functioncall
    if onclass != ""{
        $ready = *onclass.*onclassfunc(arg1,arg2,arg3,arg4,arg5,arg6,arg7)
    }
    else{
        isf = cat(2,function,"(arg1,arg2,arg3,arg4,arg5,arg6,arg7)")
        $ready = nscript::runfunction(isf)
    }

     // if its a function that doesnt return, set ready to true
     if $ready == ""{
         $ready = true
     }
     //isnt used, but gotta stay active not to exit the thread before synced back
    coroutine "thread" each 1000{
        break self
    }
}
class awaits{
    func async(function,callback,arg1,arg2,arg3,arg4,arg5,arg6,arg7){
        self.counter ++
        if self.counter > 100{
            self.counter = 0
        }
        thisthread = cat(self,@now,"_",self.counter)
        if instring(function,".") == true{
            onclass = splitselect(function,".",0)
            onclassfunc = splitselect(function,".",1)
        }
        if instring(callback,".") == true{
            cbonclass = splitselect(callback,".",0)
            cbclassfunc = splitselect(callback,".",1)
        }
        spawnthread thisthread c:*onclass v:onclass v:onclassfunc f:*function v:function v:arg1 v:arg2 v:arg3 v:arg4 v:arg5 v:arg6 v:arg7 awaits
        coroutine thisthread{
            req = TRD::*thisthread("check")
            if req != ""{
                awaits.callback(callback,req,cbonclass,cbclassfunc)
                break self
            }
        }
    }
    func callback(function,req,onclass,onclassfunc){
        if onclass == ""{
            nscript::runfunction(cat(2,function,"(req)"))
        }
        else{
            *onclass.*onclassfunc(req)
        }
        TRD::self("exit")
    }
}


