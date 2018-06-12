unit LabTreeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFTree = class(TForm)
    PnlControl: TPanel;
    BRefresh: TButton;
    ESearch: TEdit;
    BGarbachev: TButton;
    OpenDialog1: TOpenDialog;
    BOpen: TButton;
    BSave: TButton;
    procedure BRefreshClick(Sender: TObject);
    procedure BGarbachevClick(Sender: TObject);
    procedure BOpenClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure ESearchKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type
  Tpt = ^node;  // Указатель на узел
  node = record  // Узел
    Data : integer;  // Информационное поле
    Poiskkol : integer;  // Частота поиска
    left, right : Tpt;  // Левая и правая часть
  end;
var
  FTree: TFTree;
  root : Tpt;  // Корень
  standart : integer;  // искомый узел дерева
  WidthArea : integer;
  level : integer;
  f : boolean;
  File_Longname, file_Shortname : string;

implementation

{$R *.dfm}

//==============================================================================
// Добавление новой вершины-----------------------------------------------------
Procedure Insert(var x : Tpt; x_temp : integer; x_SN : integer);//x-корень,
begin
  if x = nil then
  begin
    new(x);
    x^.data := x_temp;
    x^.Poiskkol := x_SN;
    x^.left := nil;
    x^.right := nil;
  end
  else
    if x_temp <= x^.Data then
      Insert(x^.left, x_temp, x_SN)
    else
      Insert(x^.right, x_temp, x_SN);
end;

// Чтение данных из файла-------------------------------------------------------
procedure FromAFile;
var
  f : TextFile;
  x : Integer;
  x_NB : integer;
begin
  AssignFile(f, file_Shortname);
  reset(f);
  while not EOF(f) do
  begin
    read(f, x);
    readln(f, x_NB);
    Insert(root, x, x_NB);
  end;
  CloseFile(f);
end;

// Отрисовка вершины и ребра----------------------------------------------------
Procedure DrawCircle(const Level, Data, SN, L, R, x0, y0 : integer);
var  // x0, y0 - кординаты родительской вершины
  x, y : integer;  // Координаты текущей вершины
  str : string;    // Текст, который будет записан внутрь вершины
begin
  x := (r + l) div 2;
  y := Level * 80;
  Ftree.Canvas.MoveTo(x0, y0 + 20);
  Ftree.Canvas.LineTo(x + 10, y + 10);
  Ftree.Canvas.Brush.Color := clMoneyGreen;
  FTree.Canvas.Ellipse(x - 10, y - 10, x + 30, y + 30);
  str := IntTostr(Data)+ '|'+IntToStr(SN);
  FTree.Canvas.TextOut(x-7, y, str);
end;

// Отрисовка всего дерева-------------------------------------------------------
Procedure prym_print(var x:Tpt; const i, l_gr, r_gr, x0, y0 : integer);
var
  j : integer;
  x0_temp, y0_temp : integer;
begin
  if x <> nil then
  begin
    if i = 1 then
      DrawCircle(i, x^.data, x^.Poiskkol, l_gr, r_gr, ((r_gr + l_gr) div 2), 80)
    else
      DrawCircle(i, x^.data, x^.Poiskkol, l_gr, r_gr, x0, y0);
    j := i + 1;
    x0_temp := ((r_gr + l_gr) div 2) + 10;
    y0_temp :=  ((j - 1)* 80) + 10 ;
    prym_print(x^.left, j, l_gr, (((r_gr + l_gr) div 2)), x0_temp, y0_temp);
    prym_print(x^.right, j, (((r_gr + l_gr) div 2)) , r_gr, x0_temp, y0_temp);
  end;
end;

// Поиск введенной вершины------------------------------------------------------
Procedure Poisk (var x: Tpt; const isknumber : integer);
begin
  if (x <> nil) and (f = false) then
  begin
    if x^.Data = isknumber then
    begin
      inc(x^.Poiskkol);
      f := true;
    end
    else
    begin
      poisk(x^.left,  isknumber);
      poisk(x^.right, isknumber);
      if f then
        level := level + 1;
    end;
  end;
end;

// Перестройка графа------------------------------------------------------------
Procedure Gorbachev(var x: Tpt);
var
  temp : Tpt;
begin
  if (x^.left <> nil) or (x^.right <> nil) then
  begin
    if (x^.left <> nil) then
    if (x.Poiskkol < x^.left.Poiskkol) then
    begin
      new(temp);
      temp.Data :=  x.Data;
      temp.Poiskkol := x.Poiskkol;
      temp.right :=  x.right;
      temp.left := x.left.right;
      x^.Data :=   x^.left^.Data ;
      x^.Poiskkol := x^.left^.Poiskkol ;
      x^.left  :=  x^.left^.left;
      x^.right := temp ;
    end;
    if (x^.right <> nil) then
    if (x^.Poiskkol < x^.right^.Poiskkol) then
    begin
      new(temp);
      temp.Data :=  x.Data;
      temp.Poiskkol := x.Poiskkol;
      temp.left :=  x.left;
      temp.right := x.right.left;
      x^.Data :=   x^.right^.Data ;
      x^.Poiskkol := x^.right^.Poiskkol ;
      x^.right  :=  x^.right^.right;
      x^.left := temp ;
    end;
    if x.left <> nil then
      Gorbachev(x.left);
    if x.right <> nil then
      Gorbachev(x.right);
  end;
end;

// Обработка нажатия на кнопку "Искать"---------------------------------------
procedure TFTree.BGarbachevClick(Sender: TObject);
begin
  standart := StrToInt(ESearch.Text);
  f := false;
  level := 1;
  Poisk (root, standart);
  if f then
    ShowMessage('Поиск выполнен. Чтобы увидеть новое дерево, нажмите кнопку "Обновить"')
  else
    ShowMessage('Элемент не найден!');
end;

// Обработка нажатия на кнопку "Открыть"----------------------------------------
procedure TFTree.BOpenClick(Sender: TObject);
var
  i : integer;
begin
  if OpenDialog1.Execute then
     File_Longname := OpenDialog1.FileName;
  i := length(File_Longname);
  file_Shortname := '';
  while (File_Longname[i] <> '\') and (i <> 0) do
  begin
    file_Shortname := File_Longname[i] + file_Shortname;
    dec(i);
  end;
  New(root);
  root := nil;
  FromAFile;
  repaint;
end;

// Обработка нажатия на кнопку "Обновить"---------------------------------------
procedure TFTree.BRefreshClick(Sender: TObject);
var
  i : integer;
begin
  WidthArea := FTree.Width - 20 ;
  repaint;
  for i := 1 to Level do
    Gorbachev(root);
  Prym_print(root, 1, 0, WidthArea, 1, 1);
end;

// Сохраниние в файл------------------------------------------------------------
procedure NodeSave(const x : Tpt; var f : TextFile);
begin
  if x <> nil then
  begin
    Writeln(f, x^.Data,' ', x^.Poiskkol);
    NodeSave(x^.Left, f);
    NodeSave(x^.Right, f);
  end;
end;

// Подготовка к сохранению в файл-----------------------------------------------
procedure TreeSave(var root : Tpt; const FileName : String);
var
  F : TextFile;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  NodeSave(root, f);
  CloseFile(F);
end;

// Обработка нажатия на кнопку "Сохранить"--------------------------------------
procedure TFTree.BSaveClick(Sender: TObject);
begin
  TreeSave(root, file_Shortname);
  ShowMessage('Изменения сохранены!');
end;

// Проверка на ввод-------------------------------------------------------------
procedure TFTree.ESearchKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(KEY, ['0'..'9', '.', #8, #13, #27, #127]) then
    Key := #0
end;

end.

