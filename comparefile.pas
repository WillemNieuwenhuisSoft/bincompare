unit comparefile;

interface

function compare(source, target: string; var reason : string) : int64;

implementation

uses classes, sysutils, math, progress;

const BLOCKSIZE = 1000000;

function compare(source, target: string; var reason : string) : int64;
var
  srcfile, targetfile: TFileStream;
  srcblock, targetblock : TBytes;
  srcbytes, targetbytes : integer;
  total, perc, perctot : Int64;
  isequal : boolean;
  dd : double;
  prog : TProgress;
begin
    prog := TProgress.Create;
    prog.title := 'Comparing';
    prog.clean := false;

    compare := -1;

    try
        srcfile := TFileStream.Create(source, fmShareDenyWrite);
    except
        on EFOpenError do begin
            reason := 'Problem opening file: ("' + source + '")';
            exit;
        end;
    end;

    try
        targetfile := TFileStream.Create(target, fmShareDenyWrite);
    except
        on EFOpenError do begin
            reason := 'Problem opening file (' + target + ')';
            exit;
        end;
    end;

    compare := 0;

    if srcfile.Size = targetfile.Size then begin
        compare := srcfile.Size;

        setlength(srcblock, BLOCKSIZE);
        setlength(targetblock, BLOCKSIZE);
        total := 0;
        perc := srcfile.Size div 100;
        perctot := 0;
        try
            while total < srcfile.Size do begin

                srcbytes := srcfile.Read(srcblock, BLOCKSIZE);
                targetbytes := targetfile.Read(targetblock, BLOCKSIZE);
                total := total + BLOCKSIZE;

                if srcbytes <> targetbytes then begin
                    reason := 'Files differ in size';
                    exit;
                end;

                isequal := compareMem(@srcblock[0], @targetblock[0], srcbytes);

                if isequal then
                    reason := 'Files are identical'
                else
                    reason := 'Files are different';

                if total > perctot then begin
                    dd := min((total * 100.0) / srcfile.Size, 100.0);
//                    write(format(#13'Comparing %d%%'#13, [round(dd)]));
                      prog.update( trunc(dd), 100);
                    perctot := perctot + perc;
                end;
            end;

        finally
            prog.finish;
            srcfile.Free;
            targetfile.Free;
        end;
    end else begin
        reason := 'Files differ in size';
    end;
end;

end.
