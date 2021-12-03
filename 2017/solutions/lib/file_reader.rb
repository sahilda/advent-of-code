def read_file(file_name)
    data = []
    File.open("../data/#{file_name}", "r") do |file|
        file.each_line do |line|
            data << line
        end
    end
    data
end