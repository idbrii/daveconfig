// setlocal makeprg=c:/sandbox/build_cs.bat\ %
// command! ProjectRun update|compiler csc|set makeprg=c:/sandbox/build_cs.bat\ c:/sandbox/sandbox.cs|AsyncMake

using System.Collections.Generic;
using System.Collections;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System;


public static class Logger {

    [Conditional("DEBUG")]  
    public static void Assert(bool condition, string msg,
            [CallerFilePath] string file = "",
            [CallerMemberName] string member = "",
            [CallerLineNumber] int line = 0
            )
    {
        // Debug.Assert will open a msg box, so implement our own.
        if (!condition)
        {
            // Follow style of C# error messages.
            Console.WriteLine($"{file}({line}): assert: in {member}: {msg}");
        }
    }

    [Conditional("DEBUG")]  
    public static void AssertEqual(uint a, uint b, string msg = "",
            [CallerFilePath] string file = "",
            [CallerMemberName] string member = "",
            [CallerLineNumber] int line = 0
            )
    {
        // Debug.Assert will open a msg box, so implement our own.
        if (a != b)
        {
            // Follow style of C# error messages.
            Console.WriteLine($"{file}({line}): assert: in {member}: {a} != {b} {msg}");
        }
    }

    public static void Log(string msg)
    {
        Console.WriteLine(msg);
    }
}


class Program {

        static void Main(string[] args) {
            Logger.Log($"{1} {2}");
            Logger.Assert(1 == 2, $"{1} {2}");
        }

}
