require 'English'

class WrappedIO
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

describe 'Process#spawn' do
  subject {  }
  context 'when called with out: set to an instance of WrappedIO' do
    let(:out) { WrappedIO.new($stdout) }
    it 'should call to_io to get the wrapped IO object' do
      pid = Process.spawn('exit 0', out: out)
      _pid, status = Process.wait2(pid)
      expect(out.to_io_called?).to eq(true)
    end
  end
end
