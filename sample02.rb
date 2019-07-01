# hamaknさんの解答コード

require "byebug"

# http://nabetani.sakura.ne.jp/yokohamarb/103mask/

def solve(mask)
  # 0. 入力を、1a(16) => 26(10) => 11010(2) にする
  # 1. 11010(2) => [2, 8, 16] にする
  # 2. arrの要素数で分岐する、4つ以下 or それ以上
  #   2a. 全部のconbinationを取って、数字変換して、終わり
  #   2b. 下4つの組み合わせの前13つと、最後2つを取って、終わり

  arr = []
  x = 1
  # "1a" => 26 => "11010" => "01011" => "0" "1" "0" "1" "1"
  mask.to_i(16).to_s(2).to_s.reverse.each_char.with_index do |str, i|
    if str == "1"
      arr << x
    end
    x *= 2
  end
  # => [2, 8, 16]

  # when arr:[2, 8, 16] => [2,8,10,16,18,24,26]
  res =
    if arr.size <= 4
      solve_S(arr) # 2a
    else
      solve_L(arr) # 2b
    end

  res.join(",")
end

def solve_S(arr)
  res = []
  # (0...(2 ** 3)).to_a => [0, 1, 2, 3, 4, 5, 6, 7]
  (0...(2 ** arr.size)).to_a.each do |i|
    next if i == 0

    sum = 0
    # arr = [2, 8, 16]
    arr.each_with_index do |a, j|
      # (1 << j) 左シフト演算子は左辺の数値を右辺の値だけ左へシフトする。
      # (1 << j) => (1 << 0)
      # 1(10) => 1(2)
      # 左辺の数値 1(2)を右辺の数値 0だけ左へシフトする
      # => 1

      # ビットANDは演算子の左辺と右辺の同じ位置にあるビットを比較して、両方のビットが共に「1」の場合だけ「1」にする。
      # i & 1 => 1 & 1 => 1
      sum += a if i & (1 << j) > 0 # てきとう FIXME
    end
    res << sum
  end
  res
end

def solve_L(arr)
  res = []

  res_mini = solve_S(arr[0..4])
  res << res_mini[0..12]

  res << "..."

  sum = arr.sum
  # max - 1
  res << sum - arr[0]
  # max
  res << sum

  res
end

# from http://nabetani.sakura.ne.jp/yokohamarb/103mask/

require "minitest/autorun"
require "json"

if ! ARGV[0] || ! File.exist?( ARGV[0] )
  raise "you should specify json file as ARGV[0]"
end

class TestYokohamaRb103 < Minitest::Test
  json_string = File.open( ARGV[0], &:read )
  data = JSON.parse( json_string, symbolize_names:true )
  data[:test_data].each do | number:, src:, expected: |
    define_method( :"test_#{number}" ) do
      actual = solve(src)
      assert_equal( expected, actual )
    end
  end
end

# =>
# Run options: --seed 43946
#
# Running:
#
# .......................................................
#
# Finished in 0.005546s, 9917.0574 runs/s, 9917.0574 assertions/s.
#
# 55 runs, 55 assertions, 0 failures, 0 errors, 0 skips
