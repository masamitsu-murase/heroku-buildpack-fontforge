#!/usr/bin/env ruby
# % bin/copy_shared_libraries.rb bin_file lib_dir

require "fileutils"

exit 1 unless ARGV.size ==2 && File.file?(ARGV[0]) && File.directory?(ARGV[1])

TARGET_SO_LIST = ["libpython2.7.so", "libutil.so"]
DEST_DIR = ARGV[1]

output = `ldd #{ARGV[0]}`
output.each_line.map do |line|
    line = line.chomp
    if TARGET_SO_LIST.any?{ |i| line.start_with?(i) }
        name, path_addr = line.split("=>").map(&:strip)
        path = path_addr.split(" ")[0]
        FileUtils.cp_r(path, DEST_DIR, verbose: true, dereference_root: true)
    end
end
