# What are PCH files?
> I found this option in Visual Studio/clang/GCC that lets me create PCH files. These files seem to be magic: if I add includes to it, I don't need to worry about including them anywhere. Great!

> Even better, when using Unreal Engine, it automatically creates these PCH.h files. Amazing!

**No**. Not great. Not amazing. PCH files are a compiler optimiztion to reduce build times. However, we defeat this benefit if we add unnecessary headers to the PCH. Let's look at an example.

# Example

BattleDirectorEditorPrivatePCH.h

	// Copyright 2016, idbrii
	#pragma once

	#include "BattleDirectorEditorModule.h"
	#include "BattleDirectorRuntimeClasses.h"

	// ...

	// Add this new header.
	#include "Demonstration.h"


Demonstration.h

	// Copyright 2016, idbrii
	#pragma once

	// hello

Now let's compile to set our baseline.

If we compile again without making any changes, our build completes almost immediately because the build system does a dependency check to avoid building unnecessary files.

	1>  Performing full C++ include scan (building a new target)
	1>  Target is up to date.
	========== Build: 1 succeeded, 0 failed, 3 up-to-date, 0 skipped ==========

Let's modify a .cpp and see how long a no-op change takes (add a comment to BattleGraph.cpp).

	1>      Rebuild All: 1 succeeded, 0 failed, 0 skipped
	1>
	1>  XGE execution time: 6.32 seconds
	========== Build: 1 succeeded, 0 failed, 3 up-to-date, 0 skipped ==========

Now let's modify Demonstration.

Demonstration.h

	// Copyright 2016, idbrii
	#pragma once

	// hello
	// modification

Nothing includes Demonstration, so this should build in < 10 seconds.

	1>      Rebuild All: 1 succeeded, 0 failed, 0 skipped
	1>
	1>
	1>  XGE execution time: 66.48 seconds
	========== Build: 1 succeeded, 0 failed, 3 up-to-date, 0 skipped ==========

Instead, the build takes **more than a minute** on a distributed build system! (XGE is incredibuild.)

It compiled tons of cpp files. Why?

# How PCH files work
A PCH file is a precompiled header file. That means that it gets compiled and we use the compiled form wherever it's included. This means we can skip all the work of processing its contents for each compile. To benefit from the PCH, it needs to be included in all your CPP files. The UnrealHeaderTool requires you to put the PCH as the first include in your cpp files.

In C++, when a header changes anything that includes it needs to be recompiled.

PCH files follow this rule. Changing a PCH means recompiling **everything that includes it**. That means your entire module must recompile.

Similarly, if we change any header that is included in the PCH, we need to recompile the PCH and then recompile the entire module.

So if you put lots of your header files in your PCH, then you'll constantly be recompiling the entire module.

It's not all bad. The PCH is great for Unreal header files since we don't modify them. Also, fundamental headers that nearly everything in your module will include anyway are also good candidates.

# Unreal PCH details
Every module needs a Private PCH file that will be included in all of your cpp files.

The UnrealHeaderTool requires you to put the PCH as the first include in your cpp files.

Sometimes Unreal's generated code for objects requires you to include EngineMinimal.h in your PCH. (Theoretically, you could find all the classes and include them, but since it's buried deep in generated code and the output is unclear it's easier to add EngineMinimal.h to the PCH. Since EngineMinimal.h won't change often, this is an acceptable trade-off.

# Even more details
See [Bruce Dawson's writeup on PCH](http://www.cygnus-software.com/papers/precompiledheaders.html) for an in-depth (albeit dated) look.

