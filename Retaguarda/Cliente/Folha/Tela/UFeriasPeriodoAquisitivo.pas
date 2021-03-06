{ *******************************************************************************
Title: T2Ti ERP
Description: Janela F�rias Per�odos Aquisitivos para o m�dulo Folha de Pagamento

The MIT License

Copyright: Copyright (C) 2016 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The author may be contacted at:
t2ti.com@gmail.com</p>

@author Albert Eije
@version 2.0
******************************************************************************* }

unit UFeriasPeriodoAquisitivo;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, FeriasPeriodoAquisitivoVO, 
  FeriasPeriodoAquisitivoController;

  type

  TFFeriasPeriodoAquisitivo = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditIdColaborador: TLabeledCalcEdit;
    EditColaborador: TLabeledEdit;
    EditDataInicio: TLabeledDateEdit;
    EditDataFim: TLabeledDateEdit;
    EditAfastamentoPrevidencia: TLabeledCalcEdit;
    ComboBoxSituacao: TLabeledComboBox;
    EditLimiteParaGozo: TLabeledDateEdit;
    ComboBoxDescontarFaltas: TLabeledComboBox;
    ComboBoxDesconsiderarAfastamento: TLabeledComboBox;
    EditAfastamentoSemRemuneracao: TLabeledCalcEdit;
    EditAfastamentoComRemuneracao: TLabeledCalcEdit;
    EditDiasDireito: TLabeledCalcEdit;
    EditDiasGozados: TLabeledCalcEdit;
    EditDiasFaltas: TLabeledCalcEdit;
    EditDiasRestantes: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditIdColaboradorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FFeriasPeriodoAquisitivo: TFFeriasPeriodoAquisitivo;

implementation

uses ViewPessoaColaboradorVO, ViewPessoaColaboradorController;

{$R *.lfm}

{$REGION 'Controles Infra'}
procedure TFFeriasPeriodoAquisitivo.BotaoConsultarClick(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  i: integer;
begin
  inherited;

  if Sessao.Camadas = 2 then
  begin
    Filtro := MontaFiltro;

    CDSGrid.Close;
    CDSGrid.Open;
    ConfiguraGridFromVO(Grid, ClasseObjetoGridVO);

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TFeriasPeriodoAquisitivoController.Consulta(Filtro, IntToStr(Pagina));
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSGrid.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSGrid.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSGrid.Post;
      RetornoConsulta.Next;
    end;
  end;
end;

procedure TFFeriasPeriodoAquisitivo.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFFeriasPeriodoAquisitivo.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFeriasPeriodoAquisitivoVO;
  ObjetoController := TFeriasPeriodoAquisitivoController.Create;

  inherited;
  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFeriasPeriodoAquisitivo.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFFeriasPeriodoAquisitivo.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFFeriasPeriodoAquisitivo.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TFeriasPeriodoAquisitivoController.Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    BotaoConsultar.Click;
end;

function TFFeriasPeriodoAquisitivo.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TFeriasPeriodoAquisitivoVO.Create;

      TFeriasPeriodoAquisitivoVO(ObjetoVO).IdColaborador := EditIdColaborador.AsInteger;

      /// EXERCICIO
      ///  Inclua o nome do colaborador

      //TFeriasPeriodoAquisitivoVO(ObjetoVO).ColaboradorNome := EditColaborador.Text;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DataInicio := EditDataInicio.Date;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DataFim := EditDataFim.Date;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).Situacao := IntToStr(ComboBoxSituacao.ItemIndex);
      TFeriasPeriodoAquisitivoVO(ObjetoVO).LimiteParaGozo := EditLimiteParaGozo.Date;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DescontarFaltas := IfThen(ComboBoxDescontarFaltas.ItemIndex = 0, 'S', 'N');
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DesconsiderarAfastamento := IfThen(ComboBoxDesconsiderarAfastamento.ItemIndex = 0, 'S', 'N');
      TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoPrevidencia := EditAfastamentoPrevidencia.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoSemRemun := EditAfastamentoSemRemuneracao.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoComRemun := EditAfastamentoComRemuneracao.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasDireito := EditDiasDireito.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasGozados := EditDiasGozados.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasFaltas := EditDiasFaltas.AsInteger;
      TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasRestantes := EditDiasRestantes.AsInteger;

      if StatusTela = stInserindo then
      begin
        TFeriasPeriodoAquisitivoController.Insere(TFeriasPeriodoAquisitivoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TFeriasPeriodoAquisitivoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TFeriasPeriodoAquisitivoController.Altera(TFeriasPeriodoAquisitivoVO(ObjetoVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFFeriasPeriodoAquisitivo.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TFeriasPeriodoAquisitivoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdColaborador.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).IdColaborador;
//    EditColaborador.Text := TFeriasPeriodoAquisitivoVO(ObjetoVO).ColaboradorPessoaNome;
    EditDataInicio.Date := TFeriasPeriodoAquisitivoVO(ObjetoVO).DataInicio;
    EditDataFim.Date := TFeriasPeriodoAquisitivoVO(ObjetoVO).DataFim;
    ComboBoxSituacao.ItemIndex := StrToInt(TFeriasPeriodoAquisitivoVO(ObjetoVO).Situacao);
    EditLimiteParaGozo.Date := TFeriasPeriodoAquisitivoVO(ObjetoVO).LimiteParaGozo;
    ComboBoxDescontarFaltas.ItemIndex := AnsiIndexStr(TFeriasPeriodoAquisitivoVO(ObjetoVO).DescontarFaltas, ['S', 'N']);
    ComboBoxDesconsiderarAfastamento.ItemIndex := AnsiIndexStr(TFeriasPeriodoAquisitivoVO(ObjetoVO).DesconsiderarAfastamento, ['S', 'N']);
    EditAfastamentoPrevidencia.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoPrevidencia;
    EditAfastamentoSemRemuneracao.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoSemRemun;
    EditAfastamentoComRemuneracao.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).AfastamentoComRemun;
    EditDiasDireito.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasDireito;
    EditDiasGozados.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasGozados;
    EditDiasFaltas.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasFaltas;
    EditDiasRestantes.AsInteger := TFeriasPeriodoAquisitivoVO(ObjetoVO).DiasRestantes;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFFeriasPeriodoAquisitivo.EditIdColaboradorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
  ViewPessoaColaboradorVO :TViewPessoaColaboradorVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdColaborador.Value <> 0 then
      Filtro := 'ID = ' + EditIdColaborador.Text
    else
      Filtro := 'ID=0';

    try
      EditColaborador.Clear;

        ViewPessoaColaboradorVO := TViewPessoaColaboradorController.ConsultaObjeto(Filtro);
        if Assigned(ViewPessoaColaboradorVO) then
      begin
        EditColaborador.Text := ViewPessoaColaboradorVO.Nome;
      end
      else
      begin
        Exit;
      end;
    finally
      EditDataInicio.SetFocus;
    end;
  end;
end;
{$ENDREGION}

end.


