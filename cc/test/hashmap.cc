//siehe http://www.heise.de/foren/go.shtml?read=1&msg_id=5241951&forum_id=44546

#include <string>
#include <ext/hash_map> // Muss in "ext/" liegen.

struct FileInfo {};

/*
//geht nicht, offenbar wg. der "&"s in der Signatur von hash::operator()??

namespace __gnu_cxx {
    template<>
    struct hash<std::string &>
    {
        
        size_t operator()(std::string &str) const
        {
            __gnu_cxx::hash<char const*> H;
            return H(str.c_str() );
        }
    };
}

int main() {
    // Den "__gnu_cxx" namespace muss ich hier auch angeben.
    // (huh?)
    __gnu_cxx::hash_map<std::string, FileInfo*> cache;
    FileInfo *info = cache["filename"];
}
*/

/*
//geht
namespace __gnu_cxx {

    template<> struct hash<std::string> {
        size_t operator()(std::string s) const {
            //return hash<const char*>::operator()(s.c_str());
            __gnu_cxx::hash<const char*> h;
            return h(s.c_str());
        }
    };
    
}

int main() {
    __gnu_cxx::hash_map<std::string, FileInfo*> cache;
    FileInfo *info = cache["filename"];
}
*/


struct myhash {
    size_t operator()(const std::string &str) const {
        __gnu_cxx::hash<const char *> H;
        return H(str.c_str() );
    }

};

int main() {
    __gnu_cxx::hash_map<std::string, FileInfo*, myhash> cache;
    FileInfo *info = cache["filename"];
}

/*
//das geht nicht, weil "Hash Function" ein refinement
//von "assignable" ist. Normale C++-Funktionen sind nicht "assignable".

size_t myhash(const std::string &str) {
    __gnu_cxx::hash<char const*> H;
    return H(str.c_str() );
}

int main() {
    __gnu_cxx::hash_map<std::string, FileInfo*, myhash> cache;
    FileInfo *info = cache["filename"];
}
*/


//krank...
