#include <map>
#include <string>

class Meins;

class Meins{
public:  
  std::string val;
  Meins() {}
  Meins( const Meins& other) 
    : val(other.val) {}
  Meins( const std::string& other) 
    : val(other) {}
  const Meins& operator=( const char* other ) 
  { val = other; return *this; }

  static std::map<std::string, Meins> meine;
};



int main() {
}

