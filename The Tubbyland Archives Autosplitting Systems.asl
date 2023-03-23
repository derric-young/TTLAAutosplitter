state("ttla-act1-2-0") {}
state("the-tubbyland-archives-act-1-v1-0-1") {}
state("the-tubbyland-archives-act-1") {}

init
{
	var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
	var ptr = scanner.Scan(new SigScanTarget(2, "8B 3D ???????? 8B F7"));
	if (ptr == IntPtr.Zero) throw new NullReferenceException("Sigscanning failed!");
	vars.FrameID = new MemoryWatcher<int>(new DeepPointer(game.ReadPointer(ptr), game.ReadValue<int>(ptr + 0xC)));
}

update
{
	vars.FrameID.Update(game);
}

start {
  if(vars.FrameID.Current == 3 || vars.FrameID.Current == 7 && vars.FrameID.Old == 11) {
    return true;
  }
}

split {
  if(vars.FrameID.Current == 5 && vars.FrameID.Old == 4 ||
  vars.FrameID.Current == 5 && vars.FrameID.Old == 11 ||
  vars.FrameID.Current == 7 && vars.FrameID.Old == 6 ||
  vars.FrameID.Current == 12 && vars.FrameID.Old == 11 ||
  vars.FrameID.Current == 1 && vars.FrameID.Old == 7 ||
  vars.FrameID.Current == 1 && vars.FrameID.Old == 0 ||
  vars.FrameID.Current == 11 && vars.FrameID.Old == 7) {
    return true;
  }
}

isLoading {
  if(vars.FrameID.Current == 4) {
    return true;
  }
  else {
    return false;
  }
}