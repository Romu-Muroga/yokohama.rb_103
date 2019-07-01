require "minitest/autorun"
require "json"
require "byebug"

def solve(src)
  mask = src.to_i(16)
  numbers = []
  (1..mask).to_a.each do |n|
    if (mask & n) == n
      numbers << n
    end
  end

  if numbers.count > 15
    from_head_to_13th = numbers[0..12]
    two_from_the_end = numbers[-2..-1]
    numbers = from_head_to_13th + ["..."] + two_from_the_end
  end
  numbers.join(",")
end

if ! ARGV[0] || ! File.exist?( ARGV[0] )
  raise "you should specify json file as ARGV[0]"
end

class TestYokohamaRb103 < Minitest::Test
  json_string = File.open( ARGV[0], &:read )
  data = JSON.parse( json_string, symbolize_names:true )
  # {"number":0,"src":"1a","expected":"2,8,10,16,18,24,26"}
  data[:test_data].each do | number:, src:, expected: |
    define_method( :"test_#{number}" ) do
      actual = solve(src)
      assert_equal( expected, actual )
    end
  end
end
