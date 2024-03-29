require 'English'
require 'tmpdir'

describe 'Process#spawn' do
  let(:wrapped_io_class) do
    Class.new do
      def initialize(io_writer)
        @io_writer = io_writer
        @to_io_called = false
      end

      def to_io
        @to_io_called = true
        @io_writer
      end

      def to_io_called?
        @to_io_called
      end
    end
  end

  context 'when called with out: set to an instance of WrappedIO' do
    it 'should not raise an error' do
      out = wrapped_io_class.new(STDOUT)
      expect do
        Process.wait(Process.spawn('exit 0', out: out))
      end.not_to raise_error
    end

    it 'should call #to_io to get the wrapped IO object' do
      out = wrapped_io_class.new(STDOUT)
      Process.wait(Process.spawn('exit 0', out: out))
      expect(out.to_io_called?).to eq(true)
    end

    it 'should redirect stdout of the subprocess to the wrapped IO object' do
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          f = File.open('out.txt', 'wb')
          out = wrapped_io_class.new(f)
          Process.wait(Process.spawn('echo "Hello World"', out: out))
          f.close

          expect(File.read('out.txt')).to match(/Hello World/)
        end
      end
    end
  end
end
