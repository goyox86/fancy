module Rubinius

  class Compiler

    def self.fancy_compiled_name(file)
      if file.suffix? ".fy"
        file + "c"
      else
        file + ".compiled.rbc"
      end
    end

    def self.compile_fancy_file(file, output = nil, line = 1, transforms = :fancy)
      compiler = new :fancy_file, :compiled_file

      parser = compiler.parser
      parser.root AST::Script

      if transforms.kind_of? Array
        transforms.each { |t| parser.enable_category t }
      else
        parser.enable_category transforms
      end

      parser.input file, line

      # parser.print
      printer = compiler.packager.print
      printer.bytecode = true

      writer = compiler.writer
      writer.name = output ? output : fancy_compiled_name(file)

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{file}", e
      end
    end

  end

end