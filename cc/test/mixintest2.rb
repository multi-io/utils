module ConstrainedCollection

  def push(x)
    if size() > 5
      raise "Collection wird zu gross!"
    end
    print "fuege Element hinzu: #{x}\n";
    super(x)
  end

end




arr=[1,2]
arr.push 3
=> [1, 2, 3]
irb(main):004:0> arr.extend ConstrainedCollection
=> [1, 2, 3]
irb(main):005:0> arr.push 4
fuege Element hinzu: 4
=> [1, 2, 3, 4]
irb(main):006:0> arr.push 5
fuege Element hinzu: 5
=> [1, 2, 3, 4, 5]
irb(main):007:0> arr.push 6
fuege Element hinzu: 6
=> [1, 2, 3, 4, 5, 6]
irb(main):008:0> arr.push 7
