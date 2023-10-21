// Autonomus Splitting Systems for TTLA

// State's (This is Neccessary as Autosplitters Requiare This for Proper Funtion)
state("ttla-act1-2-0") {}
state("the-tubbyland-archives-act-1-v1-0-1") {}
state("the-tubbyland-archives-act-1") {}
state("ttla-thedream") {}
state("ttla-act1-2-5-0") {}
state("ttla-act1-2.6.2") {}
// the EXE Names Here happen to Be the Defualt EXE Names This Game was Distributed With
// This is the Init Code. Its Purpose is to Get the Code Scan for the Game, Detects if its Act's 1-4 or The Dream (Act 2-4 not supported as there not out) and Sets the Values for the Proper Code Execution.
init
{
//  This Code Scans For the Current Frame Number. The Frame Number is the Scene like on Other Game Engines. Just Refered to as Frames in Clickteam Fusion 2.5
    var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
    var ptr = scanner.Scan(new SigScanTarget(2, "8B 3D ???????? 8B F7"));
    if (ptr == IntPtr.Zero) throw new NullReferenceException("Sigscanning failed!");
    vars.FrameID = new MemoryWatcher<int>(new DeepPointer(game.ReadPointer(ptr), game.ReadValue<int>(ptr + 0xC)));
//  This Part Replaces the Current EXE Names to instead of being for example being whatever act it is also  defualts vars.version to X
    var gameName = game.ProcessName.ToLower().Replace("-", " ");
    vars.version = 'X';
//  This Detects if the Game is Act 1 or Part B
    if (gameName.Contains("act 1"))
    {
        version = "Act 1";
        vars.version = '1';
    }
    else if (gameName.Contains("act1"))
    {
        version = "Act 1";
        vars.version = '1';
    }  
    else if (gameName.Contains("thedream"))
    {
        version = "The Dream";
        vars.version = 'D';
    }
    timer.IsGameTimePaused = false;
    vars.TimerModel = new TimerModel { CurrentState = timer };
}
// This Pauses the Timer when None of the Parts are Open. the Timer is Unpaused With the Last Line of the Init Code.
exit
{
    timer.IsGameTimePaused = true;
    vars.isopen = 0;
    if (version == "The Dream") {
	vars.TimerModel.Split();
    }
}
// This is the Update Code. The First and Second Line
update
{
    if (vars.version == 'X')
        return false;

    vars.FrameID.Update(game);


    switch ((char)vars.version)
    {
        case '1':
      	refreshRate = 60;
            	break;
        case 'D':
      	refreshRate = 60;
            	break;
    }
}
// this is the start code. what it does is it starts the timer. frameid 13 and 14 are cutscene splits for either the intro to the game or the minatar ballora cutscene. 3 and 2 are just the load screens.
start {
  if(vars.FrameID.Current == 3  && version == "Act 1" ||
  vars.FrameID.Current == 7 && vars.FrameID.Old == 11  && version == "Act 1" ||
  vars.FrameID.Current == 2 && vars.FrameID.Old == 1 && version == "The Dream") {
    return true;
  }
}
// Resetting. This Only Resets on the Intro Cutscene of Act 1. Nothing Else
reset {
  if(vars.FrameID.Current == 3 && vars.FrameID.Old == 1 && version == "Act 1" ||
	vars.FrameID.Current == 0 && version == "The Dream") {
    return true;
  }
}
isLoading {
  if(vars.FrameID.Current == 4 && version == "Act 1") {
    return true;
  }
  else {
    return false;
  }
}
// Splits. This Contains All the Splitting Funtonality of the Game. From Act 1 to B
split {
  if(vars.FrameID.Current == 5 && vars.FrameID.Old == 4 && version == "Act 1" ||
  vars.FrameID.Current == 5 && vars.FrameID.Old == 11 && version == "Act 1" ||
  vars.FrameID.Current == 7 && vars.FrameID.Old == 6 && version == "Act 1" ||
  vars.FrameID.Current == 12 && vars.FrameID.Old == 11 && version == "Act 1" ||
  vars.FrameID.Current == 1 && vars.FrameID.Old == 7 && version == "Act 1" ||
  vars.FrameID.Current == 1 && vars.FrameID.Old == 0 && version == "Act 1" ||
  vars.FrameID.Current == 11 && vars.FrameID.Old == 7 && version == "Act 1" ||
  vars.FrameID.Current == 2 && vars.FrameID.Old == 1 && version == "The Dream") {
    return true;
  }
}
