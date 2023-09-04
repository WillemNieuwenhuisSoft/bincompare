unit progress;

interface

type
    TProgress = class
    private
        FStdOut : THandle;
        msg : string;
        msgwidth : integer;
        barwidth : integer;
        suffix : string;
        front_bar : string;
        back_bar : string;
        space : char;
        mark : char;
        _clean : boolean;

        function getWidth : integer;
    public
        property title : string read msg write msg;
        property clean : boolean read _clean write _clean;

        constructor Create;

        procedure update(progress : integer; max : integer);
        procedure finish;
    end;

implementation

{ TProgress }

uses
    sysutils, windows;

constructor TProgress.Create;
begin
    FStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
    msg := '';
    msgwidth := 20;
    barwidth := 50;
    suffix := ' %d/%d';
    front_bar := '|';
    back_bar  := '|';
    space := ' ';
    mark := '#';
    clean := true;
    barwidth := getWidth - msgwidth - 10 - 1; // -1 to prevent flushing to next line
end;

function TProgress.getWidth : integer;
var
  BufferInfo: TConsoleScreenBufferInfo;
begin
    if FStdOut = INVALID_HANDLE_VALUE then
        getWidth := 80;

    if not GetConsoleScreenBufferInfo(FStdOut, BufferInfo) then
        getWidth := 80;

    getWidth := BufferInfo.srWindow.Right - BufferInfo.srWindow.Left + 1;

end;

procedure TProgress.finish;
begin
    if clean then
        write(#13 + StringOfChar(space, self.msgwidth + self.barwidth + 10));

    writeln;
end;

procedure TProgress.update(progress : integer; max : integer);
var
    filled : integer;
    empty : integer;
    line : string;
begin
    filled := trunc(self.barwidth * progress / 100.0);
    empty := self.barwidth - filled;

    line := #13 + self.msg.PadRight(self.msgwidth)
                + front_bar
                + StringOfChar(mark, filled).PadRight(self.barwidth)
                + back_bar
                + format(suffix, [progress, max]) ;
    write(line);
end;

end.
