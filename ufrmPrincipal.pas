unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, cxMaskEdit,
  cxSpinEdit, cxDBEdit, cxTextEdit, ACBrBase, ACBrEnterTab, Vcl.Buttons,
  Vcl.DBActns, System.Actions, Vcl.ActnList, frxClass, Vcl.ExtCtrls, frxDBSet;

type
  TfrmPrincipal = class(TForm)
    dts_cliente: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    entertab: TACBrEnterTab;
    Button1: TButton;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label3: TLabel;
    inserir: TButton;
    cancelar: TButton;
    salvar: TButton;
    excluir: TButton;
    Label4: TLabel;
    dts_cidade: TDataSource;
    Edit1: TEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    panel: TPanel;
    Panel2: TPanel;
    editar: TButton;
    Panel1: TPanel;
    frxDBDataset1: TfrxDBDataset;
    frxReport1: TfrxReport;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure inserirClick(Sender: TObject);
    procedure cancelarClick(Sender: TObject);
    procedure salvarClick(Sender: TObject);
    procedure editarClick(Sender: TObject);
    procedure excluirClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    procedure insercao;
    procedure normal;
    { Private declarations }
  public
    { Public declarations }
    desc: boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses udmConexao, ufrmProduto;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  frmProduto := TfrmProduto.Create(nil);
  try
    frmProduto.ShowModal;
    dts_cliente.DataSet.FieldByName('id_produto').AsInteger :=
      frmProduto.codprod;
    Edit1.Text := frmProduto.descprod;
  finally
    frmProduto.Free;
  end;
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  dts_cliente.DataSet.Refresh;
end;

procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  if not dmConexao.cds_cliente.IsEmpty then
  begin
    frxDBDataset1.DataSet := dmConexao.cds_cliente;
    frxReport1.LoadFromFile('cliente.fr3');
    frxReport1.ShowReport;
  end;
end;

procedure TfrmPrincipal.cancelarClick(Sender: TObject);
begin
  dts_cliente.DataSet.cancel;
  normal;
end;

procedure TfrmPrincipal.DBGrid1DrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with DBGrid1 do
  begin
    if dts_cliente.DataSet.State in [dsEdit, dsInsert, dsBrowse] then
      // Cor da linha selecionada
      if (Rect.Top = TStringGrid(DBGrid1).CellRect(DataCol,
        TStringGrid(DBGrid1).Row).Top) or (gdSelected in State) then
      begin
        Canvas.FillRect(Rect);
        Canvas.Brush.Color := clYellow;
        DefaultDrawDataCell(Rect, Column.Field, State)
      end;
  end;
end;

procedure TfrmPrincipal.DBGrid1TitleClick(Column: TColumn);
var
  sql: string;
  sort: string;
  comando: string;
begin
  dmConexao.qry_cliente.Close;
  dmConexao.qry_cliente.sql.Clear;

  if (desc) then
    sort := 'desc'
  else
    sort := 'asc';
  sql := 'select cli. id as id,cli.descricao as descricao,cli.id_produto as id_produto,'
    + 'cli.id_cidade as id_cidade,cli.idade as idade,ci.nome as cidade ,p.descricao as produto'
    + ' from cliente as cli inner join cidade as ci on ci.id=cli.id_cidade ' +
    'inner join produto as p on p.id=cli.id_produto ';
  comando := sql + ' order by ' + Column.FieldName + ' ' + sort;
  dmConexao.qry_cliente.sql.Add(comando);
  dmConexao.qry_cliente.Open;
  dts_cliente.DataSet.Refresh;
  desc := not desc;

end;

procedure TfrmPrincipal.editarClick(Sender: TObject);
begin

  dts_cliente.DataSet.Edit;
  insercao;
end;

procedure TfrmPrincipal.excluirClick(Sender: TObject);
begin
  dts_cliente.DataSet.delete;
  normal;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  desc := true;
  normal;
end;

procedure TfrmPrincipal.inserirClick(Sender: TObject);
begin
  insercao;
  dts_cliente.DataSet.Insert;
end;

procedure TfrmPrincipal.salvarClick(Sender: TObject);
begin

  try
    dts_cliente.DataSet.post;
    normal;
  except
    on e: exception do
    begin
      showmessage('Ocorreu o seguinte erro: ' + e.message);
      insercao;
    end;

  end;
end;

procedure TfrmPrincipal.insercao;
begin
  salvar.Enabled := true;
  cancelar.Enabled := true;
  inserir.Enabled := false;
  excluir.Enabled := false;
  editar.Enabled := false;
  panel.Enabled := true;
  DBEdit3.SetFocus;
end;

procedure TfrmPrincipal.normal;
begin
  salvar.Enabled := false;
  cancelar.Enabled := false;
  editar.Enabled := true;
  inserir.Enabled := true;
  excluir.Enabled := true;
  panel.Enabled := false;
end;

end.
