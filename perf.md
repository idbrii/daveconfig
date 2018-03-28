
## DOP

Watch [CppCon 2014: Mike Acton "Data-Oriented Design and C++"](https://www.youtube.com/watch?v=rX0ItVEVjHc), because it explains the motivation of why to do DOP. The speaker, Mike Acton, is now working on ECS at Unity. You can also read [his code review of Ogre](https://www.bounceapp.com/116294) and the Ogre team's [very reasonable response](http://www.yosoygames.com.ar/wp/2013/11/on-mike-actons-review-of-ogrenode-cpp/).

If all of those are too long, then his [Typical C++ Bullshit](https://macton.smugmug.com/Other/2008-07-15-by-Eye-Fi/n-xmKDH/i-BrHWXdJ) is a quick primer using a specific example for how iterating objects is bad.

## SOA vs AOS

Using structures of arrays is really about cache hits/misses.

Imagine you're coding a football game. You could store your team data in two manners:

    // An array of structures:
    struct Player {
        Vector3 position;
        Quat rotation;
        Vector3 velocity;
        string name;
        Country birth_country;
        Country team_country;
        int player_number;
        // ...
    };
    var team = new Player[MAX_PLAYERS];

    // A structure of arrays:
    struct Players {
        Vector3[] position;
        Quat[] rotation;
        Vector3[] velocity;
        string[] name;
        Country[] birth_country;
        Country[] team_country;
        int[] player_number;
        // ...
    }
    var team = new Players();

Imagine you want to tick their movement. You multiply their velocity by delta time and add it to their position. When you access their data (position, velocity), you will load that data into your cache. Cache prefetching will load in surrounding data too.

With the array of structures, you process one structure (player) at a time. But since we don't care about the surrounding data, we blew our cache and the next player will be a cache miss.

With the structure of arrays, you process two elements of arrays (relevant data) at a time. This time, the surrounding data is the next player (and the one after that), we'll get cache hits.

[ref](https://www.reddit.com/r/gamedev/comments/87ikb9/ecs_newb_seeking_clarity/dwdhpxa/)
