unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, StdCtrls, Grids, ComCtrls, XPMan,
  ExtCtrls, Buttons, Organ, ToolWin, Menus, MMSystem, VirtualTrees, ImgList,
  ActiveX, ShellAPI, ComObj, ListenFormUnit, CheckLst, ObjectMatrixFrameUnit,
  Themes, UxTheme, ShlObj, WoodFormUnit, ScanFormUnit, ExportFormUnit,
  WarningFormUnit, ConfigurationFormUnit, SplashFormUnit;

type
  TDataState = (dsOrganStructure, dsStopStructure, dsRankStructure, dsPanelStructure);
  TDataStates = set of TDataState;

  TOrganNode = record
    Data: TObject;
  end;
  POrganNode = ^TOrganNode;

  TOrganDragObject = class(TDragObjectEx)
  private
    FData: TObject;
  public
    constructor Create(AData: TObject);
    destructor Destroy; override;

    property Data: TObject read FData;
  end;

  TWoodArea = record
    Rect: TRect;
    Index: Integer;
  end;

  TMainForm = class(TForm)
    PageControlMain: TPageControl;
    TabSheetOrganStructure: TTabSheet;
    SplitterOrganStructure: TSplitter;
    GroupBoxOrganStructure: TGroupBox;
    TreeViewOrganStructure: TTreeView;
    PageControlStructureProperties: TPageControl;
    TabSheetOrganProperties: TTabSheet;
    LabelChurchName: TLabel;
    LabelChurchAddress: TLabel;
    LabelOrganBuilder: TLabel;
    LabelOrganBuildDate: TLabel;
    LabelOrganComments: TLabel;
    LabelRecordingDetails: TLabel;
    LabelInfoFilename: TLabel;
    ButtonInfoFilename: TSpeedButton;
    LabelNumberOfManuals: TLabel;
    LabelNumberOfStopFamilies: TLabel;
    LabelNumberOfPanels: TLabel;
    EditChurchName: TEdit;
    EditChurchAddress: TEdit;
    EditOrganBuilder: TEdit;
    EditOrganBuildDate: TEdit;
    EditOrganComments: TEdit;
    EditRecordingDetails: TEdit;
    EditInfoFilename: TEdit;
    EditNumberOfManuals: TEdit;
    UpDownNumberOfManuals: TUpDown;
    CheckBoxHasPedals: TCheckBox;
    EditNumberOfStopFamilies: TEdit;
    UpDownNumberOfStopFamilies: TUpDown;
    EditNumberOfPanels: TEdit;
    UpDownNumberOfPanels: TUpDown;
    GroupBoxMainPanelButtonSizes: TGroupBox;
    LabelMainPanelDrawstopWidth: TLabel;
    LabelMainPanelDrawstopHeight: TLabel;
    LabelMainPanelPistonWidth: TLabel;
    LabelMainPanelPistonHeight: TLabel;
    CheckBoxMainPanelDefaultButtonSize: TCheckBox;
    EditMainPanelDrawstopWidth: TEdit;
    UpDownMainPanelDrawstopWidth: TUpDown;
    EditMainPanelDrawstopHeight: TEdit;
    UpDownMainPanelDrawstopHeight: TUpDown;
    EditMainPanelPistonWidth: TEdit;
    UpDownMainPanelPistonWidth: TUpDown;
    EditMainPanelPistonHeight: TEdit;
    UpDownMainPanelPistonHeight: TUpDown;
    GroupBoxMainPanelSize: TGroupBox;
    LabelMainPanelWidth: TLabel;
    LabelMainPanelHeight: TLabel;
    ComboBoxMainPanelWidth: TComboBox;
    ComboBoxMainPanelHeight: TComboBox;
    TabSheetManualProperties: TTabSheet;
    LabelManualName: TLabel;
    LabelManualAbbreviatedName: TLabel;
    LabelManualComment: TLabel;
    LabelManualNumberOfKeys: TLabel;
    LabelManualFirstKey: TLabel;
    LabelManualAppearance: TLabel;
    BevelOrganStructure1: TBevel;
    BevelOrganStructure2: TBevel;
    EditManualName: TEdit;
    EditManualAbbreviatedName: TEdit;
    EditManualComment: TEdit;
    EditManualNumberOfKeys: TEdit;
    UpDownManualNumberOfKeys: TUpDown;
    EditManualFirstKey: TEdit;
    UpDownManualFirstKey: TUpDown;
    CheckBoxManualInvisible: TCheckBox;
    ComboBoxManualAppearance: TComboBox;
    GroupBoxEnclosure: TGroupBox;
    LabelEnclosureMinimumLevel: TLabel;
    CheckBoxEnclosure: TCheckBox;
    EditEnclosureMinimumLevel: TEdit;
    UpDownEnclosureMinimumLevel: TUpDown;
    GroupBoxTremulant: TGroupBox;
    LabelTremulantPeriod: TLabel;
    LabelTremulantStartRate: TLabel;
    LabelTremulantStopRate: TLabel;
    LabelTremulantAmpModDepth: TLabel;
    CheckBoxTremulant: TCheckBox;
    EditTremulantPeriod: TEdit;
    UpDownTremulantPeriod: TUpDown;
    EditTremulantStartRate: TEdit;
    UpDownTremulantStartRate: TUpDown;
    EditTremulantStopRate: TEdit;
    UpDownTremulantStopRate: TUpDown;
    EditTremulantAmpModDepth: TEdit;
    UpDownTremulantAmpModDepth: TUpDown;
    GroupBoxCouplers: TGroupBox;
    VirtualStringTreeCouplers: TVirtualStringTree;
    TabSheetCouplersProperties: TTabSheet;
    LabelCouplersDrawstopImage: TLabel;
    LabelCouplersPistonImage: TLabel;
    LabelCouplersFontName: TLabel;
    LabelCouplersFontColor: TLabel;
    LabelCouplerDrawstopFontSize: TLabel;
    LabelCouplersPistonFontSize: TLabel;
    ComboBoxCouplersDrawstopImage: TComboBox;
    ComboBoxCouplersPistonImage: TComboBox;
    ComboBoxCouplersFontName: TComboBox;
    ComboBoxCouplersFontColor: TComboBox;
    EditCouplersDrawstopFontSize: TEdit;
    UpDownCouplersDrawstopFontSize: TUpDown;
    EditCouplersPistonFontSize: TEdit;
    UpDownCouplersPistonFontSize: TUpDown;
    GroupBoxCouplersExample: TGroupBox;
    PaintBoxCouplersExample: TPaintBox;
    TabSheetTremulantsProperties: TTabSheet;
    LabelTremulantsDrawstopImage: TLabel;
    LabelTremulantsPistonImage: TLabel;
    LabelTremulantsFontName: TLabel;
    LabelTremulantsFontColor: TLabel;
    LabelTremulantsDrawstopFontSize: TLabel;
    LabelTremulantsPistonFontSize: TLabel;
    ComboBoxTremulantsDrawstopImage: TComboBox;
    ComboBoxTremulantsPistonImage: TComboBox;
    ComboBoxTremulantsFontName: TComboBox;
    ComboBoxTremulantsFontColor: TComboBox;
    EditTremulantsDrawstopFontSize: TEdit;
    UpDownTremulantsDrawstopFontSize: TUpDown;
    EditTremulantsPistonFontSize: TEdit;
    UpDownTremulantsPistonFontSize: TUpDown;
    GroupBoxTremulantsExample: TGroupBox;
    PaintBoxTremulantsExample: TPaintBox;
    TabSheetEnclosuresProperties: TTabSheet;
    LabelEnclosuresImage: TLabel;
    LabelEnclosuresFontName: TLabel;
    LabelEnclosuresFontColor: TLabel;
    LabelEnclosuresFontSize: TLabel;
    ComboBoxEnclosuresImage: TComboBox;
    ComboBoxEnclosuresFontName: TComboBox;
    ComboBoxEnclosuresFontColor: TComboBox;
    EditEnclosuresFontSize: TEdit;
    UpDownEnclosuresFontSize: TUpDown;
    GroupBoxEnclosuresExample: TGroupBox;
    PaintBoxEnclosuresExample: TPaintBox;
    TabSheetStopFamilyProperties: TTabSheet;
    LabelStopFamilyName: TLabel;
    LabelStopFamilyDrawstopImage: TLabel;
    LabelStopFamilyPistonImage: TLabel;
    LabelStopFamilyFontName: TLabel;
    LabeStopFamilyFontColor: TLabel;
    LabelStopFamilyDrawstopFontSize: TLabel;
    LabelStopFamilyPistonFontSize: TLabel;
    EditStopFamilyName: TEdit;
    CheckBoxStopFamilyHasPiston: TCheckBox;
    ComboBoxStopFamilyDrawstopImage: TComboBox;
    ComboBoxStopFamilyPistonImage: TComboBox;
    ComboBoxStopFamilyFontName: TComboBox;
    ComboBoxStopFamilyFontColor: TComboBox;
    EditStopFamilyDrawstopFontSize: TEdit;
    UpDownStopFamilyDrawstopFontSize: TUpDown;
    EditStopFamilyPistonFontSize: TEdit;
    UpDownStopFamilyPistonFontSize: TUpDown;
    GroupBoxStopFamilyExample: TGroupBox;
    PaintBoxStopFamilyExample: TPaintBox;
    TabSheetWaveSamples: TTabSheet;
    SplitterWaveSamples: TSplitter;
    GroupBoxRanks: TGroupBox;
    ToolBarRanks: TToolBar;
    ButtonAddRanks: TToolButton;
    ButtonRemoveRank: TToolButton;
    ButtonClearRanks: TToolButton;
    ButtonSeparator1: TToolButton;
    ButtonListenRank: TToolButton;
    VirtualStringTreeRanks: TVirtualStringTree;
    GroupBoxStops: TGroupBox;
    BevelWaveSamples: TBevel;
    ToolBarStops: TToolBar;
    ButtonAddStop: TToolButton;
    ButtonDeleteStop: TToolButton;
    VirtualStringTreeStops: TVirtualStringTree;
    PageControlStopProperties: TPageControl;
    TabSheetStopProperties: TTabSheet;
    LabelStopName: TLabel;
    LabelStopFamily: TLabel;
    EditStopName: TEdit;
    ComboBoxStopFamily: TComboBox;
    TabSheetRankProperties: TTabSheet;
    LabelRankChannelAssignment: TLabel;
    LabelRankHarmonicNumber: TLabel;
    CheckBoxRankPercusive: TCheckBox;
    ComboBoxRankChannelAssignment: TComboBox;
    ComboBoxRankHarmonicNumber: TComboBox;
    GroupBoxRankReleases: TGroupBox;
    CheckListBoxRankReleases: TCheckListBox;
    TabSheetPanelLayout: TTabSheet;
    SplitterStopLayout: TSplitter;
    PanelPanelLayout: TPanel;
    BevelPanelLayout1: TBevel;
    GroupBoxPanelStructure: TGroupBox;
    TreeViewPanelStructure: TTreeView;
    GroupBoxButtons: TGroupBox;
    VirtualStringTreeButtons: TVirtualStringTree;
    PageControlPanelProperties: TPageControl;
    TabSheetMainPanel: TTabSheet;
    BevelPanelLayout2: TBevel;
    BevelPanelLayout3: TBevel;
    GroupBoxMainPanelLabels: TGroupBox;
    LabelMainPanelLabelsImage: TLabel;
    LabelMainPanelLabelsFontName: TLabel;
    LabelMainPanelLabelsFontColor: TLabel;
    LabelMainPanelLabelsFontSize: TLabel;
    ComboBoxMainPanelLabelsImage: TComboBox;
    ComboBoxMainPanelLabelsFontName: TComboBox;
    ComboBoxMainPanelLabelsFontColor: TComboBox;
    EditMainPanelLabelsFontSize: TEdit;
    UpDownMainPanelLabelsFontSize: TUpDown;
    GroupBoxMainPanelTrims: TGroupBox;
    CheckBoxMainPanelTrimAboveManuals: TCheckBox;
    CheckBoxMainPanelTrimBelowManuals: TCheckBox;
    CheckBoxMainPanelTrimAboveExtraRows: TCheckBox;
    GroupBoxMainPanelPreview: TGroupBox;
    PanelMainPanelPreview: TPanel;
    PaintBoxMainPanelPreview: TPaintBox;
    TabSheetMainPanelLeftStopjamb: TTabSheet;
    PanelMainPanelLeftStopjamb: TPanel;
    LabelMainPanelLeftStopjambWidth: TLabel;
    LabelMainPanelLeftStopjambHeight: TLabel;
    LabelMainPanelLeftStopjambLayout: TLabel;
    EditMainPanelLeftStopjambWidth: TEdit;
    UpDownMainPanelLeftStopjambWidth: TUpDown;
    EditMainPanelLeftStopjambHeight: TEdit;
    UpDownMainPanelLeftStopjambHeight: TUpDown;
    ComboBoxMainPanelLeftStopjambLayout: TComboBox;
    CheckBoxMainPanelLeftStopjambPairDrawstopCols: TCheckBox;
    ObjectMatrixFrameMainPanelLeftStopjamb: TObjectMatrixFrame;
    TabSheetMainPanelRightStopjamb: TTabSheet;
    PanelMainPanelRightStopjamb: TPanel;
    LabelMainPanelRightStopjambWidth: TLabel;
    LabelMainPanelRightStopjambHeight: TLabel;
    LabelMainPanelRightStopjambLayout: TLabel;
    EditMainPanelRightStopjambWidth: TEdit;
    UpDownMainPanelRightStopjambWidth: TUpDown;
    EditMainPanelRightStopjambHeight: TEdit;
    UpDownMainPanelRightStopjambHeight: TUpDown;
    ComboBoxMainPanelRightStopjambLayout: TComboBox;
    CheckBoxMainPanelRightStopjambPairDrawstopCols: TCheckBox;
    ObjectMatrixFrameMainPanelRightStopjamb: TObjectMatrixFrame;
    TabSheetMainPanelCenterStopjamb: TTabSheet;
    PanelMainPanelCenterStopjamb: TPanel;
    LabelMainPanelCenterStopjambWidth: TLabel;
    LabelMainPanelCenterStopjambHeight: TLabel;
    EditMainPanelCenterStopjambWidth: TEdit;
    UpDownMainPanelCenterStopjambWidth: TUpDown;
    EditMainPanelCenterStopjambHeight: TEdit;
    UpDownMainPanelCenterStopjambHeight: TUpDown;
    ObjectMatrixFrameMainPanelCenterStopjamb: TObjectMatrixFrame;
    TabSheetMainPanelPistons: TTabSheet;
    BevelPanelLayout6: TBevel;
    PanelMainPanelPistons: TPanel;
    BevelPanelLayout4: TBevel;
    BevelPanelLayout5: TBevel;
    GroupBoxMainPanelManualPistons: TGroupBox;
    LabelMainPanelPistonMatrixWidth: TLabel;
    LabelMainPanelButtonsAboveManuals: TLabel;
    EditMainPanelPistonMatrixWidth: TEdit;
    UpDownMainPanelPistonMatrixWidth: TUpDown;
    ComboBoxMainPanelButtonsAboveManuals: TComboBox;
    GroupBoxMainPanelBottomPistons: TGroupBox;
    LabelMainPanelBottomPistonMatrixHeight: TLabel;
    LabelMainPanelPistonsLayout: TLabel;
    EditMainPanelBottomPistonMatrixHeight: TEdit;
    UpDownMainPanelBottomPistonMatrixHeight: TUpDown;
    ComboBoxMainPanelPistonsLayout: TComboBox;
    GroupBoxMainPanelTopPistons: TGroupBox;
    LabelMainPanelTopPistonMatrixHeight: TLabel;
    LabelMainPanelExtraDrawstopRowsAboveExtraButtonRow: TLabel;
    EditMainPanelTopPistonMatrixHeight: TEdit;
    UpDownMainPanelTopPistonMatrixHeight: TUpDown;
    ComboBoxMainPanelExtraDrawstopRowsAboveExtraButtonRow: TComboBox;
    ObjectMatrixFrameMainPanelPistons: TObjectMatrixFrame;

    MainMenu: TMainMenu;
    MenuItemFile: TMenuItem;
    MenuItemNew: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemSeparator1: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemSaveAs: TMenuItem;
    MenuItemSeparator2: TMenuItem;
    MenuItemInspect: TMenuItem;
    MenuItemExport: TMenuItem;
    MenuItemSeparator3: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemHelpIndex: TMenuItem;
    MenuItemSeparator4: TMenuItem;
    MenuItemAbout: TMenuItem;
    OpenDialogProject: TOpenDialog;
    SaveDialogProject: TSaveDialog;
    SaveDialogExport: TSaveDialog;
    OpenDialogInfoFilename: TOpenDialog;
    ColorDialog: TColorDialog;
    XPManifest: TXPManifest;
    ImageListLarge: TImageList;
    ImageListSmall: TImageList;
    ImageListWave: TImageList;
    ImageListDrawstops: TImageList;
    ImageListPistons: TImageList;
    ImageListWoods: TImageList;
    ImageListLabels: TImageList;
    ImageListKeyboard: TImageList;
    ImageListPedalboard: TImageList;
    ImageListStopsLayout: TImageList;
    ImageListPistonsLayout: TImageList;
    ImageListEnclosures: TImageList;
    MenuItemSettings: TMenuItem;
    MenuItemSeparator5: TMenuItem;
    MenuitemReopen: TMenuItem;
    
    procedure GenericTreeViewChange(Sender: TObject;
      Node: TTreeNode);
    procedure GenericUpDownDataChange(Sender: TObject;
      Button: TUDBtnType);
    procedure GenericDataChange(Sender: TObject);
    procedure ComboBoxColorDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure GenericComboBoxColorChange(Sender: TObject);
    procedure VirtualStringTreeStopsMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure VirtualStringTreeStopsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure GenericVirtualStringTreeChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure ButtonAddStopClick(Sender: TObject);
    procedure VirtualStringTreeRanksGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTreeRanksShortenString(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const S: WideString; TextSpace: Integer; var Result: WideString;
      var Done: Boolean);
    procedure VirtualStringTreeRanksCompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode; Column: TColumnIndex;
      var Result: Integer);
    procedure ButtonListenRankClick(Sender: TObject);
    procedure VirtualStringTreeRanksStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure VirtualStringTreeStopsDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure VirtualStringTreeStopsDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer;
      Mode: TDropMode);
    procedure VirtualStringTreeStopsShortenString(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const S: WideString; TextSpace: Integer; var Result: WideString;
      var Done: Boolean);
    procedure VirtualStringTreeStopsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure VirtualStringTreeStopsDblClick(Sender: TObject);
    procedure ButtonDeleteStopClick(Sender: TObject);
    procedure ButtonRemoveRankClick(Sender: TObject);
    procedure VirtualStringTreeRanksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonClearRanksClick(Sender: TObject);
    procedure VirtualStringTreeStopsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VirtualStringTreeButtonsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTreeButtonsMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure VirtualStringTreeButtonsGetImageIndexEx(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer;
      var ImageList: TCustomImageList);
    procedure VirtualStringTreeStopsGetImageIndexEx(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer;
      var ImageList: TCustomImageList);
    procedure VirtualStringTreeRanksGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTreeCouplersAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure VirtualStringTreeCouplersNodeClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure VirtualStringTreeCouplersGetText(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: WideString);
    procedure VirtualStringTreeButtonsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure MenuItemExportClick(Sender: TObject);
    procedure ButtonInfoFilenameClick(Sender: TObject);
    procedure MenuItemNewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
    procedure MenuItemSaveAsClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonAddRanksClick(Sender: TObject);
    procedure GenericComboBoxDrawItemImage(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PaintBoxStopFamilyExamplePaint(Sender: TObject);
    procedure PaintBoxMainPanelPreviewPaint(Sender: TObject);
    procedure PaintBoxMainPanelPreviewMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMainPanelPreviewMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure VirtualStringTreeRanksDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer;
      Mode: TDropMode);
    procedure VirtualStringTreeRanksDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure MenuItemInspectClick(Sender: TObject);
    procedure PaintBoxEnclosuresExamplePaint(Sender: TObject);
    procedure MenuItemSettingsClick(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemFileClick(Sender: TObject);
    procedure MenuItemHelpIndexClick(Sender: TObject);
  private
    FDataSync: TDataStates;
    FUpdating: Boolean;
    FOrgan: TOrgan;
    FCurrentOrganObject: TObject;
    FCurrentStopObject: TObject;
    FCurrentRankObject: TRank;
    FCurrentPanelObject: TObject;
    FCurrentButtonObject: TObject;
    FMainPanelAreas: array of TWoodArea;
    FPanelMainPanelPreviewWindowProc: TWndMethod;
    FPanelMainPanelPreviewTracking: Boolean;
    FNormalPosition: TPoint;
    FNormalSize: TSize;

    procedure PanelMainPanelPreviewWindowProc(var Message: TMessage);

    procedure MenuItemRecentClick(Sender: TObject);

    procedure WMPosChanged(var Message: TMessage); message WM_WINDOWPOSCHANGED;
  protected
    function QuerySaveFile: Boolean;

    procedure StoreState;
    function IsNodeVisible(Tree: TVirtualStringTree; Node: PVirtualNode): Boolean;

    function BrowseForFolder(var Path: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize;

    procedure UpdateGUI;
    procedure UpdateData;

    procedure ResetGUI(ResetTab: Boolean);

    property Organ: TOrgan read FOrgan;
    property DataSync: TDataStates read FDataSync write FDataSync;

    property NormalPosition: TPoint read FNormalPosition;
    property NormalSize: TSize read FNormalSize;
  end;

var
  MainForm: TMainForm;

  S_Organ: string = 'Organ';
  S_ManualsAndDivisions: string = 'Manuals & divisions';
  S_StopAndPedalFamilies: string = 'Stop & pedal families';
  S_Couplers: string = 'Couplers';
  S_Tremulants: string = 'Tremulants';
  S_Enclosures: string = 'Enclosures';
  S_NamedManual: string = 'Manual : %s';
  S_CouplersStopFamily: string = 'Stop family : Couplers';
  S_TremulantsStopFamily: string = 'Stop family : Tremulants';
  S_NamedStopFamily: string = 'Stop family : %s';
  S_MainPanel: string = 'Main panel';
  S_LeftStopjamb: string = 'Left stopjamb';
  S_RightStopjamb: string = 'Right stopjamb';
  S_CenterStopjamb: string = 'Center stopjamb';
  S_Pistons: string = 'Pistons';
  S_Untitled: string = 'Untitled';
  S_Modified: string = 'modified';
  S_CustomColor: string = 'Custom...';
  S_Division: string = 'Division';
  S_Stop: string = 'Stop';
  S_NewStopName: string = 'Stop #%d';
  S_NewStop: string = 'New stop...';
  S_InputName: string = 'Name :';
  S_StopFamily: string = 'Stop family';
  S_Coupler: string = 'Coupler';
  S_Tremulant: string = 'Tremulant';
  S_Piston: string = 'Piston';
  S_ProjectModifiedQuerySaveChanges: string = 'Project [%s] has been modified, save changes?';
  S_Confirmation: string = 'Confirmation';
  S_SelectPathToExplore: string = 'Select a root directory to scan for pipe samples';
  S_DrawstopOn: string = 'Drawstop ON';
  S_DrawstopOff: string = 'Drawstop OFF';
  S_PistonOn: string = 'Piston ON';
  S_PistonOff: string = 'Piston OFF';
  S_Example: string = 'Example';
  S_BackgroundNames: array[0 .. 4] of string = ('drawstops', 'console', 'pistons', 'keyboard border', 'drawstops inset');
  S_BackgroundImages: string = 'Background images';
  S_NamedBackgroundImageToEdit: string = 'Background image: %s (click to edit)';
  S_NoProblemDetected: string = 'No problem detected.';
  S_Information: string = 'Information';


implementation

{$R *.dfm}

{ TOrganDragObject }

constructor TOrganDragObject.Create(AData: TObject);
begin
  inherited Create;
  FData := AData;
end;

destructor TOrganDragObject.Destroy;
begin
  if FData is TList then
    FData.Destroy;
  inherited;
end;

{ TForm1 }

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TMainForm.Destroy;
begin
  inherited;
  FreeAndNil(FOrgan);
end;

procedure TMainForm.StoreState;
var
  e: TVTVirtualNodeEnumerator;
  p: POrganNode;
begin
  e := VirtualStringTreeStops.Nodes(True).GetEnumerator;
  try
    repeat
      p := VirtualStringTreeStops.GetNodeData(e.Current);
      if Assigned(p) then
        (p.Data as TOrganObject).Tag1 := Integer(VirtualStringTreeStops.Expanded[e.Current]);
    until not e.MoveNext;
  finally
    e.Destroy;
  end;
  e := VirtualStringTreeButtons.Nodes(True).GetEnumerator;
  try
    repeat
      p := VirtualStringTreeButtons.GetNodeData(e.Current);
      if Assigned(p) then
        (p.Data as TOrganObject).Tag2 := Integer(VirtualStringTreeButtons.Expanded[e.Current]);
    until not e.MoveNext;
  finally
    e.Destroy;
  end;
end;

procedure TMainForm.UpdateData;
var
  a: Integer;
begin
  if FUpdating then
    Exit;
  if FCurrentOrganObject is TOrgan then
    with FCurrentOrganObject as TOrgan do begin
      FOrgan.ChurchName := EditChurchName.Text;
      FOrgan.ChurchAddress := EditChurchAddress.Text;
      FOrgan.OrganBuilder := EditOrganBuilder.Text;
      FOrgan.OrganBuildDate := EditOrganBuildDate.Text;
      FOrgan.OrganComments := EditOrganComments.Text;
      FOrgan.RecordingDetails := EditRecordingDetails.Text;
      FOrgan.InfoFilename := EditInfoFilename.Text;
      if NumberOfManuals <> UpDownNumberOfManuals.Position then begin
        NumberOfManuals := UpDownNumberOfManuals.Position;
        FDataSync := [];
      end;
      if HasPedals xor CheckBoxHasPedals.Checked then begin
        HasPedals := CheckBoxHasPedals.Checked;
        FDataSync := [];
      end;
      if NumberOfStopFamilies <> UpDownNumberOfStopFamilies.Position then begin
        NumberOfStopFamilies := UpDownNumberOfStopFamilies.Position;
        Exclude(FDataSync, dsOrganStructure);
      end;
      FOrgan.Layout.DefaultButtonSize := CheckBoxMainPanelDefaultButtonSize.Checked;
      FOrgan.Layout.DrawstopWidth := UpDownMainPanelDrawstopWidth.Position;
      FOrgan.Layout.DrawstopHeight := UpDownMainPanelDrawstopHeight.Position;
      FOrgan.Layout.PistonWidth := UpDownMainPanelPistonWidth.Position;
      FOrgan.Layout.PistonHeight := UpDownMainPanelPistonHeight.Position;
      FOrgan.Layout.PanelWidth := ComboBoxMainPanelWidth.ItemIndex;
      FOrgan.Layout.PanelHeight := ComboBoxMainPanelHeight.ItemIndex;
    end;
  if FCurrentOrganObject is TManual then
    with FCurrentOrganObject as TManual do begin
      if Name <> EditManualName.Text then begin
        Name := EditManualName.Text;
        Exclude(FDataSync, dsOrganStructure);
      end;
      AbbreviatedName := EditManualAbbreviatedName.Text;
      Comment := EditManualComment.Text;
      NumberOfKeys := UpDownManualNumberOfKeys.Position;
      FirstKey := UpDownManualFirstKey.Position;
      if Invisible xor CheckBoxManualInvisible.Checked then begin
        Invisible := CheckBoxManualInvisible.Checked;
        FDataSync := FDataSync - [dsStopStructure, dsPanelStructure];
      end;
      HasEnclosure := CheckBoxEnclosure.Checked;
      EnclosureMinimumLevel := UpDownEnclosureMinimumLevel.Position;
      if HasTremulant xor CheckBoxTremulant.Checked then begin
        HasTremulant := CheckBoxTremulant.Checked;
        FDataSync := FDataSync - [dsStopStructure, dsPanelStructure];
      end;
      Tremulant.Period := UpDownTremulantPeriod.Position;
      Tremulant.StartRate := UpDownTremulantStartRate.Position;
      Tremulant.StopRate := UpDownTremulantStopRate.Position;
      Tremulant.AmpModDepth := UpDownTremulantAmpModDepth.Position;
      Appearance := ComboBoxManualAppearance.ItemIndex;
    end;
  if FCurrentOrganObject is TCouplers then begin
    FOrgan.Couplers.DrawstopImage := ComboBoxCouplersDrawstopImage.ItemIndex;
    FOrgan.Couplers.PistonImage := ComboBoxCouplersPistonImage.ItemIndex;
    FOrgan.Couplers.FontName := ComboBoxCouplersFontName.Items[ComboBoxCouplersFontName.ItemIndex];
    if ComboBoxCouplersFontColor.ItemIndex = 1 + High(GColors) then
      FOrgan.Couplers.FontColor := ComboBoxCouplersFontColor.Tag
    else
      FOrgan.Couplers.FontColor := - ComboBoxCouplersFontColor.ItemIndex;
    FOrgan.Couplers.DrawstopFontSize := UpDownCouplersDrawstopFontSize.Position;
    FOrgan.Couplers.PistonFontSize := UpDownCouplersPistonFontSize.Position;
  end;
  if FCurrentOrganObject is TTremulants then begin
    FOrgan.Tremulants.DrawstopImage := ComboBoxTremulantsDrawstopImage.ItemIndex;
    FOrgan.Tremulants.PistonImage := ComboBoxTremulantsPistonImage.ItemIndex;
    FOrgan.Tremulants.FontName := ComboBoxTremulantsFontName.Items[ComboBoxTremulantsFontName.ItemIndex];
    if ComboBoxTremulantsFontColor.ItemIndex = 1 + High(GColors) then
      FOrgan.Tremulants.FontColor := ComboBoxTremulantsFontColor.Tag
    else
      FOrgan.Tremulants.FontColor := - ComboBoxTremulantsFontColor.ItemIndex;
    FOrgan.Tremulants.DrawstopFontSize := UpDownTremulantsDrawstopFontSize.Position;
    FOrgan.Tremulants.PistonFontSize := UpDownTremulantsPistonFontSize.Position;
  end;
  if FCurrentOrganObject is TEnclosures then begin
    FOrgan.Enclosures.Image := ComboBoxEnclosuresImage.ItemIndex;
    FOrgan.Enclosures.FontName := ComboBoxEnclosuresFontName.Items[ComboBoxEnclosuresFontName.ItemIndex];
    if ComboBoxEnclosuresFontColor.ItemIndex = 1 + High(GColors) then
      FOrgan.Enclosures.FontColor := ComboBoxEnclosuresFontColor.Tag
    else
      FOrgan.Enclosures.FontColor := - ComboBoxEnclosuresFontColor.ItemIndex;
    FOrgan.Enclosures.FontSize := UpDownEnclosuresFontSize.Position;
  end;
  if FCurrentOrganObject is TStopFamily then
    with FCurrentOrganObject as TStopFamily do begin
      if Name <> EditStopFamilyName.Text then begin
        Name := EditStopFamilyName.Text;
        Exclude(FDataSync, dsOrganStructure);
      end;
      if HasPiston xor CheckBoxStopFamilyHasPiston.Checked then begin
        HasPiston := CheckBoxStopFamilyHasPiston.Checked;
        FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
      end;
      DrawstopImage := ComboBoxStopFamilyDrawstopImage.ItemIndex;
      PistonImage := ComboBoxStopFamilyPistonImage.ItemIndex;
      FontName := ComboBoxStopFamilyFontName.Items[ComboBoxStopFamilyFontName.ItemIndex];
      if ComboBoxStopFamilyFontColor.ItemIndex = 1 + High(GColors) then
        FontColor := ComboBoxStopFamilyFontColor.Tag
      else
        FontColor := - ComboBoxStopFamilyFontColor.ItemIndex;
      DrawstopFontSize := UpDownStopFamilyDrawstopFontSize.Position;
      PistonFontSize := UpDownStopFamilyPistonFontSize.Position;
    end;
  if FCurrentStopObject is TStop then
    with FCurrentStopObject as TStop do begin
      if Name <> EditStopName.Text then begin
        Name := EditStopName.Text;
        Exclude(FDataSync, dsStopStructure);
      end;
      if StopFamily <> FOrgan.StopFamily[ComboBoxStopFamily.ItemIndex] then begin
        StopFamily := FOrgan.StopFamily[ComboBoxStopFamily.ItemIndex];
        Exclude(FDataSync, dsStopStructure);
      end;
    end;
  if FCurrentStopObject is TRank then
    with FCurrentStopObject as TRank do begin
      Percussive := CheckBoxRankPercusive.Checked;
      ChannelAssignment := TChannelAssignment(ComboBoxRankChannelAssignment.ItemIndex);
      HarmonicNumber := ComboBoxRankHarmonicNumber.ItemIndex;
      for a := 0 to NumberOfReleases - 1 do
        ReleaseEnabled[a] := CheckListBoxRankReleases.Checked[a];
    end;
  if FCurrentPanelObject = FOrgan then begin
    FOrgan.Layout.Labels.Image := ComboBoxMainPanelLabelsImage.ItemIndex;
    FOrgan.Layout.Labels.FontName := ComboBoxMainPanelLabelsFontName.Items[ComboBoxMainPanelLabelsFontName.ItemIndex];
    if ComboBoxMainPanelLabelsFontColor.ItemIndex = 1 + High(GColors) then
      FOrgan.Layout.Labels.FontColor := ComboBoxMainPanelLabelsFontColor.Tag
    else
      FOrgan.Layout.Labels.FontColor := - ComboBoxMainPanelLabelsFontColor.ItemIndex;
    FOrgan.Layout.Labels.FontSize := UpDownMainPanelLabelsFontSize.Position;
    FOrgan.Layout.TrimAboveManuals := CheckBoxMainPanelTrimAboveManuals.Checked;
    FOrgan.Layout.TrimBelowManuals := CheckBoxMainPanelTrimBelowManuals.Checked;
    FOrgan.Layout.TrimAboveExtraRows := CheckBoxMainPanelTrimAboveExtraRows.Checked;
  end;
  if FCurrentPanelObject = FOrgan.Layout.LeftMatrix then begin
    if UpDownMainPanelLeftStopjambWidth.Position <> FOrgan.Layout.SideMatrixWidth then begin
      FOrgan.Layout.SideMatrixWidth := UpDownMainPanelLeftStopjambWidth.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    if UpDownMainPanelLeftStopjambHeight.Position <> FOrgan.Layout.SideMatrixHeight then begin
      FOrgan.Layout.SideMatrixHeight := UpDownMainPanelLeftStopjambHeight.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    FOrgan.Layout.DrawstopLayout := ComboBoxMainPanelLeftStopjambLayout.ItemIndex;
    if FOrgan.Layout.PairDrawstopCols xor CheckBoxMainPanelLeftStopjambPairDrawstopCols.Checked then begin
      FOrgan.Layout.PairDrawstopCols := CheckBoxMainPanelLeftStopjambPairDrawstopCols.Checked;
      Exclude(FDataSync, dsStopStructure);
    end;
  end;
  if FCurrentPanelObject = FOrgan.Layout.RightMatrix then begin
    if UpDownMainPanelRightStopjambWidth.Position <> FOrgan.Layout.SideMatrixWidth then begin
      FOrgan.Layout.SideMatrixWidth := UpDownMainPanelRightStopjambWidth.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    if UpDownMainPanelRightStopjambHeight.Position <> FOrgan.Layout.SideMatrixHeight then begin
      FOrgan.Layout.SideMatrixHeight := UpDownMainPanelRightStopjambHeight.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    FOrgan.Layout.DrawstopLayout := ComboBoxMainPanelRightStopjambLayout.ItemIndex;
    if FOrgan.Layout.PairDrawstopCols xor CheckBoxMainPanelRightStopjambPairDrawstopCols.Checked then begin
      FOrgan.Layout.PairDrawstopCols := CheckBoxMainPanelRightStopjambPairDrawstopCols.Checked;
      Exclude(FDataSync, dsStopStructure);
    end;
  end;
  if FCurrentPanelObject = FOrgan.Layout.CenterMatrix then begin
    if UpDownMainPanelCenterStopjambWidth.Position <> FOrgan.Layout.CenterMatrix.Width then begin
      FOrgan.Layout.CenterMatrix.Resize(UpDownMainPanelCenterStopjambWidth.Position, FOrgan.Layout.CenterMatrix.Height);
      Exclude(FDataSync, dsPanelStructure);
    end;
    if UpDownMainPanelCenterStopjambHeight.Position <> FOrgan.Layout.CenterMatrix.Height then begin
      FOrgan.Layout.CenterMatrix.Resize(FOrgan.Layout.CenterMatrix.Width, UpDownMainPanelCenterStopjambHeight.Position);
      Exclude(FDataSync, dsPanelStructure);
    end;
  end;
  if FCurrentPanelObject = FOrgan.Layout.PistonMatrix then begin
    if UpDownMainPanelPistonMatrixWidth.Position <> FOrgan.Layout.PistonMatrixWidth then begin
      FOrgan.Layout.PistonMatrixWidth := UpDownMainPanelPistonMatrixWidth.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    if UpDownMainPanelTopPistonMatrixHeight.Position <> FOrgan.Layout.TopPistonMatrixHeight then begin
      FOrgan.Layout.TopPistonMatrixHeight := UpDownMainPanelTopPistonMatrixHeight.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    if UpDownMainPanelBottomPistonMatrixHeight.Position <> FOrgan.Layout.BottomPistonMatrixHeight then begin
      FOrgan.Layout.BottomPistonMatrixHeight := UpDownMainPanelBottomPistonMatrixHeight.Position;
      Exclude(FDataSync, dsPanelStructure);
    end;
    FOrgan.Layout.PistonLayout := ComboBoxMainPanelPistonsLayout.ItemIndex;
    FOrgan.Layout.ExtraDrawstopRowsAboveExtraButtonRow := ComboBoxMainPanelExtraDrawstopRowsAboveExtraButtonRow.ItemIndex < 1;
    FOrgan.Layout.ButtonsAboveManuals := ComboBoxMainPanelButtonsAboveManuals.ItemIndex > 0;
  end;
  FOrgan.MarkModified;
  UpdateGUI;
end;

procedure TMainForm.UpdateGUI;
var
  a, b, c, d, e, f, h: Integer;
  g: TCouplerDelta;
  n: TTreeNode;
  s: TTabSheet;
  t: string;
  x: TOrganNode;
  y: POrganNode;
  p, q, r: PVirtualNode;
begin
  FUpdating := True;
  try
    if not (dsOrganStructure in FDataSync) then begin
      TreeViewOrganStructure.Items.BeginUpdate;
      try
        TreeViewOrganStructure.Items.Clear;
        TreeViewOrganStructure.Items.AddChild(nil, S_Organ).Data := FOrgan;
        n := TreeViewOrganStructure.Items.AddChild(TreeViewOrganStructure.Items[0], S_ManualsAndDivisions);
        //n.Data := FOrgan;
        if FOrgan.HasPedals then
          b := 0
        else
          b := 1;
        for a := b to FOrgan.NumberOfManuals do
          with TreeViewOrganStructure.Items.AddChild(n, FOrgan.Manual[a].Name) do
            Data := FOrgan.Manual[a];
        n := TreeViewOrganStructure.Items.AddChild(TreeViewOrganStructure.Items[0], S_StopAndPedalFamilies);
        //n.Data := FOrgan;
        with TreeViewOrganStructure.Items.AddChild(n, S_Couplers) do
          Data := FOrgan.Couplers;
        with TreeViewOrganStructure.Items.AddChild(n, S_Tremulants) do
          Data := FOrgan.Tremulants;
        with TreeViewOrganStructure.Items.AddChild(n, S_Enclosures) do
          Data := FOrgan.Enclosures;
        for a := 0 to FOrgan.NumberOfStopFamilies - 1 do
          with TreeViewOrganStructure.Items.AddChild(n, FOrgan.StopFamily[a].Name) do
            Data := FOrgan.StopFamily[a];
        TreeViewOrganStructure.Items[0].Expand(True);
        n := nil;
        for a := 0 to TreeViewOrganStructure.Items.Count - 1 do
          if TreeViewOrganStructure.Items[a].Data = FCurrentOrganObject then
            n := TreeViewOrganStructure.Items[a];
        TreeViewOrganStructure.Select(n);
      finally
        TreeViewOrganStructure.Items.EndUpdate;
      end;
    end;
    FCurrentOrganObject := nil;
    if Assigned(TreeViewOrganStructure.Selected) then
      FCurrentOrganObject := TObject(TreeViewOrganStructure.Selected.Data);
    if not Assigned(FCurrentOrganObject) then begin
      TreeViewOrganStructure.Select(TreeViewOrganStructure.Items[0]);
      FCurrentOrganObject := FOrgan;
    end;
    s := nil;
    if FCurrentOrganObject is TOrgan then
      with FCurrentOrganObject as TOrgan do begin
        s := TabSheetOrganProperties;
        EditChurchName.Text := FOrgan.ChurchName;
        EditChurchAddress.Text := FOrgan.ChurchAddress;
        EditOrganBuilder.Text := FOrgan.OrganBuilder;
        EditOrganBuildDate.Text := FOrgan.OrganBuildDate;
        EditOrganComments.Text := FOrgan.OrganComments;
        EditRecordingDetails.Text := FOrgan.RecordingDetails;
        EditInfoFilename.Text := FOrgan.InfoFilename;
        UpDownNumberOfManuals.Position := NumberOfManuals;
        CheckBoxHasPedals.Checked := HasPedals;
        UpDownNumberOfStopFamilies.Position := NumberOfStopFamilies;
        CheckBoxMainPanelDefaultButtonSize.Checked := FOrgan.Layout.DefaultButtonSize;
        LabelMainPanelDrawstopWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        EditMainPanelDrawstopWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelDrawstopWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelDrawstopWidth.Position := FOrgan.Layout.DrawstopWidth;
        LabelMainPanelDrawstopHeight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        EditMainPanelDrawstopHeight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelDrawstopHeight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelDrawstopHeight.Position := FOrgan.Layout.DrawstopHeight;
        LabelMainPanelPistonWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        EditMainPanelPistonWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelPistonWidth.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelPistonWidth.Position := FOrgan.Layout.PistonWidth;
        LabelMainPanelPistonheight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        EditMainPanelPistonheight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelPistonheight.Enabled := not FOrgan.Layout.DefaultButtonSize;
        UpDownMainPanelPistonHeight.Position := FOrgan.Layout.PistonHeight;
        ComboBoxMainPanelWidth.ItemIndex := FOrgan.Layout.PanelWidth;
        ComboBoxMainPanelHeight.ItemIndex := FOrgan.Layout.PanelHeight;
      end;
    if FCurrentOrganObject is TManual then
      with FCurrentOrganObject as TManual do begin
        TabSheetManualProperties.Caption := Format(S_NamedManual, [Name]);
        s := TabSheetManualProperties;
        EditManualName.Text := Name;
        EditManualAbbreviatedName.Text := AbbreviatedName;
        UpDownManualNumberOfKeys.Position := NumberOfKeys;
        UpDownManualFirstKey.Position := FirstKey;
        CheckBoxManualInvisible.Checked := Invisible;
        CheckBoxManualInvisible.Enabled := FCurrentOrganObject <> FOrgan.Manual[0];
        VirtualStringTreeCouplers.Enabled := not Invisible;
        VirtualStringTreeCouplers.BeginUpdate;
        try
          VirtualStringTreeCouplers.Clear;
          if not Invisible then begin
            if FOrgan.HasPedals then
              b := 0
            else
              b := 1;
            for a := b to FOrgan.NumberOfManuals do begin
              x.Data := FOrgan.Manual[a];
              VirtualStringTreeCouplers.AddChild(nil, Pointer(x.Data));
            end;
          end;
        finally
          VirtualStringTreeCouplers.EndUpdate;
        end;
        CheckBoxEnclosure.Checked := HasEnclosure;
        LabelEnclosureMinimumLevel.Enabled := HasEnclosure;
        EditEnclosureMinimumLevel.Enabled := HasEnclosure;
        UpDownEnclosureMinimumLevel.Enabled := HasEnclosure;
        UpDownEnclosureMinimumLevel.Position := EnclosureMinimumLevel;
        CheckBoxTremulant.Checked := HasTremulant;
        LabelTremulantPeriod.Enabled := HasTremulant;
        EditTremulantPeriod.Enabled := HasTremulant;
        UpDownTremulantPeriod.Enabled := HasTremulant;
        UpDownTremulantPeriod.Position := Tremulant.Period;
        LabelTremulantStartRate.Enabled := HasTremulant;
        EditTremulantStartRate.Enabled := HasTremulant;
        UpDownTremulantStartRate.Enabled := HasTremulant;
        UpDownTremulantStartRate.Position := Tremulant.StartRate;
        LabelTremulantStopRate.Enabled := HasTremulant;
        EditTremulantStopRate.Enabled := HasTremulant;
        UpDownTremulantStopRate.Enabled := HasTremulant;
        UpDownTremulantStopRate.Position := Tremulant.StopRate;
        LabelTremulantAmpModDepth.Enabled := HasTremulant;
        EditTremulantAmpModDepth.Enabled := HasTremulant;
        UpDownTremulantAmpModDepth.Enabled := HasTremulant;
        UpDownTremulantAmpModDepth.Position := Tremulant.AmpModDepth;
        if FCurrentOrganObject = FOrgan.Manual[0] then begin
          a := 2;
          b := Integer(ImageListPedalboard);
        end else begin
          a := 4;
          b := Integer(ImageListKeyboard);
        end;
        while ComboBoxManualAppearance.Items.Count > a do
          ComboBoxManualAppearance.Items.Delete(0);
        while ComboBoxManualAppearance.Items.Count < a do
          ComboBoxManualAppearance.Items.Add('');
        ComboBoxManualAppearance.ItemIndex := Appearance;
        if ComboBoxManualAppearance.Tag <> b then begin
          ComboBoxManualAppearance.Tag := b;
          ComboBoxManualAppearance.Invalidate;
        end;
        LabelManualAppearance.Enabled := not Invisible;
        ComboBoxManualAppearance.Enabled := not Invisible;
      end;
    if FCurrentOrganObject is TCouplers then begin
      s := TabSheetCouplersProperties;
      TabSheetCouplersProperties.Caption := S_CouplersStopFamily;
      ComboBoxCouplersDrawstopImage.ItemIndex := FOrgan.Couplers.DrawstopImage;
      ComboBoxCouplersPistonImage.ItemIndex := FOrgan.Couplers.PistonImage;
      ComboBoxCouplersFontName.ItemIndex := ComboBoxCouplersFontName.Items.IndexOf(FOrgan.Couplers.FontName);
      if FOrgan.Couplers.FontColor <= 0 then begin
        ComboBoxCouplersFontColor.Tag := 0;
        ComboBoxCouplersFontColor.ItemIndex := - FOrgan.Couplers.FontColor;
      end else begin
        ComboBoxCouplersFontColor.Tag := FOrgan.Couplers.FontColor;
        ComboBoxCouplersFontColor.ItemIndex := 1 + High(GColors);
      end;
      UpDownCouplersDrawstopFontSize.Position := FOrgan.Couplers.DrawstopFontSize;
      UpDownCouplersPistonFontSize.Position := FOrgan.Couplers.PistonFontSize;
      PaintBoxCouplersExample.Invalidate;
    end;
    if FCurrentOrganObject is TTremulants then begin
      s := TabSheetTremulantsProperties;
      TabSheetTremulantsProperties.Caption := S_TremulantsStopFamily;
      ComboBoxTremulantsDrawstopImage.ItemIndex := FOrgan.Tremulants.DrawstopImage;
      ComboBoxTremulantsPistonImage.ItemIndex := FOrgan.Tremulants.PistonImage;
      ComboBoxTremulantsFontName.ItemIndex := ComboBoxTremulantsFontName.Items.IndexOf(FOrgan.Tremulants.FontName);
      if FOrgan.Tremulants.FontColor <= 0 then begin
        ComboBoxTremulantsFontColor.Tag := 0;
        ComboBoxTremulantsFontColor.ItemIndex := - FOrgan.Tremulants.FontColor;
      end else begin
        ComboBoxTremulantsFontColor.Tag := FOrgan.Tremulants.FontColor;
        ComboBoxTremulantsFontColor.ItemIndex := 1 + High(GColors);
      end;
      UpDownTremulantsDrawstopFontSize.Position := FOrgan.Tremulants.DrawstopFontSize;
      UpDownTremulantsPistonFontSize.Position := FOrgan.Tremulants.PistonFontSize;
      PaintBoxTremulantsExample.Invalidate;
    end;
    if FCurrentOrganObject is TEnclosures then begin
      s := TabSheetEnclosuresProperties;
//      TabSheetEnclosuresProperties.Caption := 'Enclosures';
      ComboBoxEnclosuresImage.ItemIndex := FOrgan.Enclosures.Image;
      ComboBoxEnclosuresFontName.ItemIndex := ComboBoxEnclosuresFontName.Items.IndexOf(FOrgan.Enclosures.FontName);
      if FOrgan.Enclosures.FontColor <= 0 then begin
        ComboBoxEnclosuresFontColor.Tag := 0;
        ComboBoxEnclosuresFontColor.ItemIndex := - FOrgan.Enclosures.FontColor;
      end else begin
        ComboBoxEnclosuresFontColor.Tag := FOrgan.Enclosures.FontColor;
        ComboBoxEnclosuresFontColor.ItemIndex := 1 + High(GColors);
      end;
      UpDownEnclosuresFontSize.Position := FOrgan.Enclosures.FontSize;
      PaintBoxEnclosuresExample.Invalidate;
    end;
    if FCurrentOrganObject is TStopFamily then
      with FCurrentOrganObject as TStopFamily do begin
        TabSheetStopFamilyProperties.Caption := Format(S_NamedStopFamily, [Name]);
        s := TabSheetStopFamilyProperties;
        EditStopFamilyName.Text := Name;
        CheckBoxStopFamilyHasPiston.Checked := HasPiston;
        ComboBoxStopFamilyDrawstopImage.ItemIndex := DrawstopImage;
        ComboBoxStopFamilyPistonImage.ItemIndex := PistonImage;
        ComboBoxStopFamilyFontName.ItemIndex := ComboBoxStopFamilyFontName.Items.IndexOf(FontName);
        if FontColor <= 0 then begin
          ComboBoxStopFamilyFontColor.Tag := 0;
          ComboBoxStopFamilyFontColor.ItemIndex := - FontColor;
        end else begin
          ComboBoxStopFamilyFontColor.Tag := FontColor;
          ComboBoxStopFamilyFontColor.ItemIndex := 1 + High(GColors);
        end;
        UpDownStopFamilyDrawstopFontSize.Position := DrawstopFontSize;
        UpDownStopFamilyPistonFontSize.Position := PistonFontSize;
        PaintBoxStopFamilyExample.Invalidate;
      end;
    for a := 0 to PageControlStructureProperties.PageCount - 1 do
      PageControlStructureProperties.Pages[a].TabVisible := PageControlStructureProperties.Pages[a] = s;
    if not (dsStopStructure in FDataSync) then begin
      h := VirtualStringTreeStops.OffsetY;
      VirtualStringTreeStops.BeginUpdate;
      try
        VirtualStringTreeStops.Clear;
        r := nil;
        if FOrgan.HasPedals then
          b := 0
        else
          b := 1;
        for a := b to FOrgan.NumberOfManuals do begin
          x.Data := FOrgan.Manual[a];
          p := VirtualStringTreeStops.AddChild(nil, Pointer(x.Data));
          if FCurrentStopObject = x.Data then
            r := p;
          for b := 0 to FOrgan.Manual[a].NumberOfStops - 1 do begin
            x.Data := FOrgan.Manual[a].Stop[b];
            q := VirtualStringTreeStops.AddChild(p, Pointer(x.Data));
            if FCurrentStopObject = x.Data then
              r := q;
            for c := 0 to FOrgan.Manual[a].Stop[b].NumberOfRanks - 1 do begin
              x.Data := FOrgan.Manual[a].Stop[b].Rank[c];
              if FCurrentStopObject = x.Data then
                r := VirtualStringTreeStops.AddChild(q, Pointer(x.Data))
              else
                VirtualStringTreeStops.AddChild(q, Pointer(x.Data));
            end;
            VirtualStringTreeStops.Expanded[q] := Boolean(FOrgan.Manual[a].Stop[b].Tag1);
          end;
          VirtualStringTreeStops.Expanded[p] := Boolean(FOrgan.Manual[a].Tag1);
        end;
        if Assigned(r) then begin
          VirtualStringTreeStops.FullyVisible[r] := True;
          VirtualStringTreeStops.Selected[r] := True;
        end;
      finally
        VirtualStringTreeStops.EndUpdate;
      end;
      VirtualStringTreeStops.OffsetY := h;
    end;
    p := VirtualStringTreeStops.GetFirstSelected;
    if Assigned(p) then begin
      if not (dsStopStructure in FDataSync) then
        VirtualStringTreeStops.ScrollIntoView(p, False);
      FCurrentStopObject := POrganNode(VirtualStringTreeStops.GetNodeData(p))^.Data;
    end else
      FCurrentStopObject := nil;
    s := nil;
    if FCurrentStopObject is TStop then
      with FCurrentStopObject as TStop do begin
        s := TabSheetStopProperties;
        EditStopName.Text := Name;
        ComboBoxStopFamily.Items.BeginUpdate;
        try
          ComboBoxStopFamily.Items.Clear;
          for a := 0 to FOrgan.NumberOfStopFamilies - 1 do
            ComboBoxStopFamily.Items.Add(FOrgan.StopFamily[a].Name);
        finally
          ComboBoxStopFamily.Items.EndUpdate;
        end;
        ComboBoxStopFamily.ItemIndex := FOrgan.IndexOfStopFamily((FCurrentStopObject as TStop).StopFamily);
      end;
    if FCurrentStopObject is TRank then
      with FCurrentStopObject as TRank do begin
        s := TabSheetRankProperties;
        CheckBoxRankPercusive.Checked := Percussive;
        ComboBoxRankHarmonicNumber.ItemIndex := HarmonicNumber;
        ComboBoxRankChannelAssignment.ItemIndex := Integer(ChannelAssignment);
        b := CheckListBoxRankReleases.ItemIndex;
        CheckListBoxRankReleases.Items.BeginUpdate;
        try
          CheckListBoxRankReleases.Items.Clear;
          for a := 0 to NumberOfReleases - 1 do begin
            CheckListBoxRankReleases.Items.Add(ExtractFilename(ReleasePath[a]));
            CheckListBoxRankReleases.Checked[a] := ReleaseEnabled[a];
          end;
        finally
          CheckListBoxRankReleases.Items.EndUpdate;
        end;
        if b >= CheckListBoxRankReleases.Count then
          b := CheckListBoxRankReleases.Count - 1;
        CheckListBoxRankReleases.ItemIndex := b;
      end;
    for a := 0 to PageControlStopProperties.PageCount - 1 do
      PageControlStopProperties.Pages[a].TabVisible := s = PageControlStopProperties.Pages[a];
    ButtonAddStop.Enabled := (FCurrentStopObject is TManual) or (FCurrentStopObject is TStop) or (FCurrentStopObject is TRank);
    ButtonDeleteStop.Enabled := (FCurrentStopObject is TStop) or (FCurrentStopObject is TRank);
    if not (dsRankStructure in FDataSync) then begin
      h := VirtualStringTreeRanks.OffsetY;
      VirtualStringTreeRanks.BeginUpdate;
      try
        VirtualStringTreeRanks.Clear;
        r := nil;
        for a := 0 to FOrgan.NumberOfRanks - 1 do
          if not Assigned(FOrgan.Rank[a].Stop) then begin
            x.Data := FOrgan.Rank[a];
            p := VirtualStringTreeRanks.AddChild(nil, Pointer(x.Data));
            if x.Data = FCurrentRankObject then
              r := p;
          end;
        if Assigned(r) then
          VirtualStringTreeRanks.Selected[r] := True;
      finally
        VirtualStringTreeRanks.EndUpdate;
      end;
      VirtualStringTreeRanks.OffsetY := h;
    end;
    p := VirtualStringTreeRanks.GetFirstSelected;
    if Assigned(p) then
      FCurrentRankObject := POrganNode(VirtualStringTreeRanks.GetNodeData(p))^.Data as TRank
    else
      FCurrentRankObject := nil;
    ButtonRemoveRank.Enabled := Assigned(FCurrentRankObject);
    ButtonClearRanks.Enabled := VirtualStringTreeRanks.RootNodeCount > 0;
    ButtonListenRank.Enabled := Assigned(FCurrentRankObject);

    if not (dsPanelStructure in FDataSync) then begin
      TreeViewPanelStructure.Items.BeginUpdate;
      try
        TreeViewPanelStructure.Items.Clear;
        n := TreeViewPanelStructure.Items.AddChildObject(nil, S_MainPanel, FOrgan);
        n.ImageIndex := 0;
        TreeViewPanelStructure.Items.AddChildObject(n, S_LeftStopjamb, FOrgan.Layout.LeftMatrix).ImageIndex := 1;
        TreeViewPanelStructure.Items.AddChildObject(n, S_RightStopjamb, FOrgan.Layout.RightMatrix).ImageIndex := 2;
        TreeViewPanelStructure.Items.AddChildObject(n, S_CenterStopjamb, FOrgan.Layout.CenterMatrix).ImageIndex := 3;
        TreeViewPanelStructure.Items.AddChildObject(n, S_Pistons, FOrgan.Layout.PistonMatrix).ImageIndex := 4;
      finally
        TreeViewPanelStructure.Items.EndUpdate;
      end;
      TreeViewPanelStructure.Items[0].Expand(True);
      for a := 0 to TreeViewPanelStructure.Items.Count - 1 do
        if TreeViewPanelStructure.Items[a].Data = FCurrentPanelObject then
          TreeViewPanelStructure.Select(TreeViewPanelStructure.Items[a]);
    end;
    FCurrentPanelObject := nil;
    if Assigned(TreeViewPanelStructure.Selected) then
      FCurrentPanelObject := TObject(TreeViewPanelStructure.Selected.Data);
    if not Assigned(FCurrentPanelObject) then begin
      TreeViewPanelStructure.Select(TreeViewPanelStructure.Items[0]);
      FCurrentPanelObject := FOrgan;
    end;
    s := nil;
    if FCurrentPanelObject = FOrgan then begin
      s := TabSheetMainPanel;
      ComboBoxMainPanelLabelsImage.ItemIndex := FOrgan.Layout.Labels.Image;
      ComboBoxMainPanelLabelsFontName.ItemIndex := ComboBoxMainPanelLabelsFontName.Items.IndexOf(FOrgan.Layout.Labels.FontName);
      if FOrgan.Layout.Labels.FontColor <= 0 then begin
        ComboBoxMainPanelLabelsFontColor.Tag := 0;
        ComboBoxMainPanelLabelsFontColor.ItemIndex := - FOrgan.Layout.Labels.FontColor;
      end else begin
        ComboBoxMainPanelLabelsFontColor.Tag := FOrgan.Layout.Labels.FontColor;
        ComboBoxMainPanelLabelsFontColor.ItemIndex := 1 + High(GColors);
      end;
      UpDownMainPanelLabelsFontSize.Position := FOrgan.Layout.Labels.FontSize;
      CheckBoxMainPanelTrimAboveManuals.Checked := FOrgan.Layout.TrimAboveManuals;
      CheckBoxMainPanelTrimBelowManuals.Checked := FOrgan.Layout.TrimBelowManuals;
      CheckBoxMainPanelTrimAboveExtraRows.Checked := FOrgan.Layout.TrimAboveExtraRows;
      PaintBoxMainPanelPreview.Invalidate;
    end;
    if FCurrentPanelObject = FOrgan.Layout.LeftMatrix then begin
      s := TabSheetMainPanelLeftStopjamb;
      UpDownMainPanelLeftStopjambWidth.Position := FOrgan.Layout.SideMatrixWidth;
      if FOrgan.Layout.PairDrawstopCols then
        UpDownMainPanelLeftStopjambWidth.Increment := 2
      else
        UpDownMainPanelLeftStopjambWidth.Increment := 1;
      UpDownMainPanelLeftStopjambHeight.Position := FOrgan.Layout.SideMatrixHeight;
      ComboBoxMainPanelLeftStopjambLayout.ItemIndex := FOrgan.Layout.DrawstopLayout;
      CheckBoxMainPanelLeftStopjambPairDrawstopCols.Checked := FOrgan.Layout.PairDrawstopCols;
    end;
    if FCurrentPanelObject = FOrgan.Layout.RightMatrix then begin
      s := TabSheetMainPanelRightStopjamb;
      UpDownMainPanelRightStopjambWidth.Position := FOrgan.Layout.SideMatrixWidth;
      if FOrgan.Layout.PairDrawstopCols then
        UpDownMainPanelRightStopjambWidth.Increment := 2
      else
        UpDownMainPanelRightStopjambWidth.Increment := 1;
      UpDownMainPanelRightStopjambHeight.Position := FOrgan.Layout.SideMatrixHeight;
      ComboBoxMainPanelRightStopjambLayout.ItemIndex := FOrgan.Layout.DrawstopLayout;
      CheckBoxMainPanelRightStopjambPairDrawstopCols.Checked := FOrgan.Layout.PairDrawstopCols;
    end;
    if FCurrentPanelObject = FOrgan.Layout.CenterMatrix then begin
      s := TabSheetMainPanelCenterStopjamb;
      UpDownMainPanelCenterStopjambWidth.Position := FOrgan.Layout.CenterMatrix.Width;
      UpDownMainPanelCenterStopjambHeight.Position := FOrgan.Layout.CenterMatrix.Height;
    end;
    if FCurrentPanelObject = FOrgan.Layout.PistonMatrix then begin
      s := TabSheetMainPanelPistons;
      UpDownMainPanelPistonMatrixWidth.Position := FOrgan.Layout.PistonMatrixWidth;
      UpDownMainPanelTopPistonMatrixHeight.Position := FOrgan.Layout.TopPistonMatrixHeight;
      LabelMainPanelBottomPistonMatrixHeight.Enabled := FOrgan.HasPedals;
      EditMainPanelBottomPistonMatrixHeight.Enabled := FOrgan.HasPedals;
      UpDownMainPanelBottomPistonMatrixHeight.Enabled := FOrgan.HasPedals;
      UpDownMainPanelBottomPistonMatrixHeight.Position := FOrgan.Layout.BottomPistonMatrixHeight;
      LabelMainPanelPistonsLayout.Enabled := FOrgan.HasPedals;
      ComboBoxMainPanelPistonsLayout.Enabled := FOrgan.HasPedals;
      ComboBoxMainPanelPistonsLayout.ItemIndex := FOrgan.Layout.PistonLayout;
      if FOrgan.Layout.ExtraDrawstopRowsAboveExtraButtonRow then
        ComboBoxMainPanelExtraDrawstopRowsAboveExtraButtonRow.ItemIndex := 0
      else
        ComboBoxMainPanelExtraDrawstopRowsAboveExtraButtonRow.ItemIndex := 1;
      if FOrgan.Layout.ButtonsAboveManuals then
        ComboBoxMainPanelButtonsAboveManuals.ItemIndex := 1
      else
        ComboBoxMainPanelButtonsAboveManuals.ItemIndex := 0;
    end;
    for a := 0 to PageControlPanelProperties.PageCount - 1 do
      PageControlPanelProperties.Pages[a].TabVisible := s = PageControlPanelProperties.Pages[a];
    PageControlPanelProperties.ActivePage := s;

    if not (dsStopStructure in FDataSync) or not (dsPanelStructure in FDataSync) then begin
      h := VirtualStringTreeButtons.OffsetY;
      VirtualStringTreeButtons.BeginUpdate;
      try
        VirtualStringTreeButtons.Clear;
        r := nil;
        if FOrgan.HasPedals then
          f := 0
        else
          f := 1;
        for a := f to FOrgan.NumberOfManuals do begin
          x.Data := FOrgan.Manual[a];
          p := VirtualStringTreeButtons.AddChild(nil, Pointer(x.Data));
          if FCurrentButtonObject = x.Data then
            r := p;
          for b := 0 to FOrgan.NumberOfStopFamilies - 1 do begin
            d := 0;
            e := 0;
            for c := 0 to FOrgan.Manual[a].NumberOfStops - 1 do
              if FOrgan.Manual[a].Stop[c].StopFamily = FOrgan.StopFamily[b] then begin
                Inc(d);
                if not FOrgan.Layout.IsObjectOnPanel(FOrgan.Manual[a].Stop[c]) then
                  Inc(e);
              end;
            if (e > 0) or (d > 0) and (FOrgan.StopFamily[b].HasPiston) and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Piston[FOrgan.Manual[a], FOrgan.StopFamily[b]]) then begin
              x.Data := FOrgan.StopFamily[b];
              q := VirtualStringTreeButtons.AddChild(p, Pointer(x.Data));
              if FCurrentButtonObject = x.Data then
                r := q;
              for c := 0 to FOrgan.Manual[a].NumberOfStops - 1 do
                if (FOrgan.Manual[a].Stop[c].StopFamily = FOrgan.StopFamily[b]) and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Manual[a].Stop[c]) then begin
                  x.Data := FOrgan.Manual[a].Stop[c];
                  if FCurrentButtonObject = x.Data then
                    r := VirtualStringTreeButtons.AddChild(q, Pointer(x.Data))
                  else
                    VirtualStringTreeButtons.AddChild(q, Pointer(x.Data));
                end;
              if FOrgan.StopFamily[b].HasPiston and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Piston[FOrgan.Manual[a], FOrgan.StopFamily[b]]) then begin
                x.Data := FOrgan.Piston[FOrgan.Manual[a], FOrgan.StopFamily[b]];
                if FCurrentButtonObject = x.Data then
                  r := VirtualStringTreeButtons.AddChild(q, Pointer(x.Data))
                else
                  VirtualStringTreeButtons.AddChild(q, Pointer(x.Data));
              end;
              VirtualStringTreeButtons.Expanded[q] := Boolean(FOrgan.StopFamily[b].Tag2);
            end;
          end;
          d := 0;
          for b := f to FOrgan.NumberOfManuals do
            for g := cdMinus8 to cdPlus8 do
              if FOrgan.Couplers[FOrgan.Manual[a], FOrgan.Manual[b], g].Active and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Couplers[FOrgan.Manual[a], FOrgan.Manual[b], g]) then
                Inc(d);
          if (d > 0) and not FOrgan.Manual[a].Invisible then begin
            x.Data := FOrgan.Manual[a].Couplers;
            q := VirtualStringTreeButtons.AddChild(p, Pointer(x.Data));
            if FCurrentButtonObject = x.Data then
              r := q;
            for b := f to FOrgan.NumberOfManuals do
              for g := cdMinus8 to cdPlus8 do
                if FOrgan.Couplers[FOrgan.Manual[a], FOrgan.Manual[b], g].Active and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Couplers[FOrgan.Manual[a], FOrgan.Manual[b], g]) then begin
                  x.Data := FOrgan.Couplers[FOrgan.Manual[a], FOrgan.Manual[b], g];
                  if FCurrentButtonObject = x.Data then
                    r := VirtualStringTreeButtons.AddChild(q, Pointer(x.Data))
                  else
                    VirtualStringTreeButtons.AddChild(q, Pointer(x.Data));
                end;
            VirtualStringTreeButtons.Expanded[q] := Boolean(FOrgan.Manual[a].Couplers.Tag2);
          end;
          if FOrgan.Manual[a].HasTremulant and not FOrgan.Layout.IsObjectOnPanel(FOrgan.Manual[a].Tremulant) then begin
            x.Data := FOrgan.Manual[a].Tremulant;
            q := VirtualStringTreeButtons.AddChild(p, Pointer(x.Data));
            if FCurrentButtonObject = x.Data then
              r := q;
          end;
          if VirtualStringTreeButtons.GetFirstChild(p) = nil then begin
            if p = r then
              r := nil;
            VirtualStringTreeButtons.DeleteNode(p);
          end else
            VirtualStringTreeButtons.Expanded[p] := Boolean(FOrgan.Manual[a].Tag2);
        end;
        if Assigned(r) then begin
          VirtualStringTreeButtons.FullyVisible[r] := True;
          VirtualStringTreeButtons.Selected[r] := True;
        end;
      finally
        VirtualStringTreeButtons.EndUpdate;
      end;
      VirtualStringTreeButtons.OffsetY := h;
    end;
    p := VirtualStringTreeButtons.GetFirstSelected;
    if Assigned(p) then begin
      if ([dsStopStructure, dsPanelStructure] * FDataSync <> [dsStopStructure, dsPanelStructure]) and not IsNodeVisible(VirtualStringTreeButtons, p) then
        VirtualStringTreeButtons.ScrollIntoView(p, False);
      FCurrentButtonObject := POrganNode(VirtualStringTreeButtons.GetNodeData(p))^.Data;
    end else
      FCurrentButtonObject := nil;
    ObjectMatrixFrameMainPanelLeftStopjamb.UpdateGUI;
    ObjectMatrixFrameMainPanelRightStopjamb.UpdateGUI;
    ObjectMatrixFrameMainPanelCenterStopjamb.UpdateGUI;
    ObjectMatrixFrameMainPanelPistons.UpdateGUI;
    if FOrgan.Filename = '' then
      t := S_Untitled
    else
      t := FOrgan.Filename;
    if FOrgan.Modified then
      t := t + ' [' + S_Modified + ']';
    Caption := t;
    FDataSync := [dsOrganStructure, dsStopStructure, dsRankStructure, dsPanelStructure];
  finally
    FUpdating := False;
  end;
end;

procedure TMainForm.GenericTreeViewChange(Sender: TObject;
  Node: TTreeNode);
begin
//  Exclude(FDataSync, dsStopStructure);
  if not FUpdating then
    UpdateGUI;
end;

procedure TMainForm.GenericUpDownDataChange(Sender: TObject;
  Button: TUDBtnType);
begin
  UpdateData;
end;

procedure TMainForm.GenericDataChange(Sender: TObject);
begin
  UpdateData;
end;

procedure TMainForm.ComboBoxColorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  c, d: TColor;
  s: string;
begin
  with Control as TComboBox do begin
    c := Canvas.Brush.Color;
    if (Index > High(GColors)) or (Index < Low(GColors)) then begin
      d := Tag;
      s := S_CustomColor;
    end else begin
      d := GColors[Index];
      s := GColorNames[Index];
    end;
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(Rect);
    Canvas.Brush.Color := d;
    Canvas.FillRect(Classes.Rect(Rect.Left + 1, Rect.Top + 1, Rect.Left + 15, Rect.Bottom - 1));
    Canvas.Brush.Color := c;
    Inc(Rect.Left, 15);
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 1, s)
  end;
end;

procedure TMainForm.GenericComboBoxColorChange(Sender: TObject);
begin
  with Sender as TComboBox do
    if ItemIndex = High(GColorNames) + 1 then begin
      if ColorDialog.Execute then begin
        Tag := ColorDialog.Color;
        Invalidate;
        UpdateData;
      end else
        UpdateGUI;
    end else
      UpdateData;
end;

procedure TMainForm.VirtualStringTreeStopsMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  p: POrganNode;
begin
  p := Sender.GetNodeData(Node);
  if Assigned(p) then
    with p ^ do begin
      if Data is TManual then
        NodeHeight := ImageListLarge.Height + 2;
      if Data is TStop then
        NodeHeight := ImageListSmall.Height + 2;
      if Data is TRank then
        NodeHeight := ImageListSmall.Height + 2;
    end;
end;

procedure TMainForm.VirtualStringTreeStopsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '';
  with POrganNode(Sender.GetNodeData(Node))^ do begin
    if Data is TManual then
      with Data as TManual do
        CellText := Name + ' (' + S_Division + ')';
    if Data is TStop then
      with Data as TStop do
        CellText := Name + ' (' + S_Stop + ')';
    if Data is TRank then
      with Data as TRank do
        CellText := Path;
  end;
end;

procedure TMainForm.GenericVirtualStringTreeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if not FUpdating then begin
    StoreState;
    UpdateGUI;
  end;
end;

procedure TMainForm.ButtonAddStopClick(Sender: TObject);
var
  m: TManual;
  s: string;
begin
  m := nil;
  if FCurrentStopObject is TManual then
    m := FCurrentStopObject as TManual;
  if FCurrentStopObject is TStop then
    m := (FCurrentStopObject as TStop).Manual;
  if FCurrentStopObject is TRank then
    m := (FCurrentStopObject as TRank).Stop.Manual;
  Assert(Assigned(m));
  s := Format(S_NewStopName, [FOrgan.NumberOfStops + 1]);
  if InputQuery(S_NewStop, S_InputName, s) then begin
    FCurrentStopObject := FOrgan.AddStop(s, m);
    FOrgan.MarkModified;
    Exclude(FDataSync, dsStopStructure);
    UpdateGUI;
  end;
end;

procedure TMainForm.VirtualStringTreeRanksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '';
  with POrganNode(Sender.GetNodeData(Node))^ do
    if Data is TRank then
      with Data as TRank do
        case Column of
          0: CellText := Path;
          1: CellText := IntToStr(NumberOfPipes);
          2: CellText := IntToStr(FirstPipe) + '-' + GKeyNames[(FirstPipe + 3) mod 12];
          3: CellText := IntToStr(NumberOfReleases);
        end;
end;

procedure TMainForm.VirtualStringTreeRanksShortenString(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const S: WideString; TextSpace: Integer;
  var Result: WideString; var Done: Boolean);
var
  a: Integer;
begin
  case Column of
    0: begin
      if TargetCanvas.TextWidth(s) < TextSpace then begin
        Result := s;
      end else begin
        a := Length(s) - 1;
        while (a > 0) and (TargetCanvas.TextWidth('...' + Copy(s, a, Length(s) - a + 1)) < TextSpace) do
          Dec(a);
        Inc(a);
        Result := '...' + Copy(s, a, Length(s) - a + 1);
      end;
      Done := True;
    end;
  end;
end;

procedure TMainForm.VirtualStringTreeRanksCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  p1, p2: POrganNode;
begin
  p1 := Sender.GetNodeData(Node1);
  p2 := Sender.GetNodeData(Node2);
  case Column of
    0: Result := CompareStr((p1.Data as TRank).Path, (p2.Data as TRank).Path);
    1: Result := (p1.Data as TRank).NumberOfPipes - (p2.Data as TRank).NumberOfPipes;
    2: Result := (p1.Data as TRank).FirstPipe - (p2.Data as TRank).FirstPipe;
    3: Result := (p1.Data as TRank).NumberOfReleases - (p2.Data as TRank).NumberOfReleases;
  end;
end;

procedure TMainForm.ButtonListenRankClick(Sender: TObject);
begin
  if Assigned(FCurrentRankObject) then
    ListenForm.Execute(FCurrentRankObject);
end;

procedure TMainForm.VirtualStringTreeRanksStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  l: TList;
  e: TVTVirtualNodeEnumerator;
begin
  if GetKeyState(VK_CONTROL) and $80000000 = 0 then begin
    e := VirtualStringTreeRanks.SelectedNodes(True).GetEnumerator;
    try
      e.MoveNext;
      if Assigned(e.Current) then begin
        l := TList.Create;
        repeat
          l.Add(POrganNode(VirtualStringTreeRanks.GetNodeData(e.Current)).Data);
        until not e.MoveNext;
        DragObject := TOrganDragObject.Create(l);
      end;
    finally
      e.Destroy;
    end;
  end;
end;

procedure TMainForm.VirtualStringTreeStopsDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  h: THitInfo;
  p: POrganNode;
begin
  Sender.GetHitTestInfoAt(Pt.X, Pt.Y, True, h);
  if Assigned(h.HitNode) then
    p := Sender.GetNodeData(h.HitNode)
  else
    p :=nil;
  if (Source is TOrganDragObject) and Assigned(p) then
    with Source as TOrganDragObject do begin
      if p.Data is TManual then
        Accept := (FData is TRank) or (FData is TList);
      if p.Data is TStop then
        Accept := (FData is TRank) or (FData is TList);
      if p.Data is TRank then
        Accept := (FData is TRank) or (FData is TList);
    end;
end;

procedure TMainForm.VirtualStringTreeStopsDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  a, b: Integer;
  h: THitInfo;
  p: POrganNode;
  s: string;
  x: TStop;
begin
  Sender.GetHitTestInfoAt(Pt.X, Pt.Y, True, h);
  if Assigned(h.HitNode) then
    p := Sender.GetNodeData(h.HitNode)
  else
    p :=nil;
  if (Source is TOrganDragObject) and Assigned(p) then
    with Source as TOrganDragObject do begin
      if p.Data is TManual then begin
        if FData is TRank then
          with FData as TRank do begin
            s := ExtractFilename(Path);
            if InputQuery(S_NewStop, S_InputName, s) then begin
              FOrgan.AddStop(s, p.Data as TManual).InsertRank(FData as TRank, 0);
              FOrgan.MarkModified;
              FCurrentStopObject := FData;
              FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
            end;
          end;
        if FData is TList then
          with TList(FData) do
            if Count > 0 then begin
              s := ExtractFilename(TRank(Items[0]).Path);
              if InputQuery(S_NewStop, S_InputName, s) then begin
                x := FOrgan.AddStop(s, p.Data as TManual);
                for a := 0 to Count - 1 do
                  x.InsertRank(TRank(Items[a]), 0);
                FOrgan.MarkModified;
                FCurrentStopObject := TRank(Items[Count - 1]);
                FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
              end;
            end;
      end;
      if p.Data is TStop then
        with p.Data as TStop do begin
          if FData is TRank then begin
            InsertRank(FData as TRank, NumberOfRanks);
            FOrgan.MarkModified;
            FCurrentStopObject := FData;
            FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
          end;
          if FData is TList then
            with TList(FData) do
              if Count > 0 then begin
                for a := 0 to Count - 1 do
                  InsertRank(TRank(Items[a]), NumberOfRanks);
                FOrgan.MarkModified;
                FCurrentStopObject := TRank(Items[Count - 1]);
                FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
              end;
        end;
      if p.Data is TRank then
        with p.Data as TRank do begin
          if FData is TRank then begin
            Stop.InsertRank(FData as TRank, Stop.IndexOfRank(p.Data as TRank));
            FOrgan.MarkModified;
            FCurrentStopObject := FData;
            FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
          end;
          if FData is TList then
            with TList(FData) do
              if Count > 0 then begin
                b := Stop.IndexOfRank(p.Data as TRank);
                for a := 0 to Count - 1 do
                  Stop.InsertRank(TRank(Items[a]), b + a);
                FOrgan.MarkModified;
                FCurrentStopObject := TRank(Items[Count - 1]);
                FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
              end;
        end;
      Sender.SetFocus;
      UpdateGUI;
    end;
end;

procedure TMainForm.VirtualStringTreeStopsShortenString(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const S: WideString; TextSpace: Integer;
  var Result: WideString; var Done: Boolean);
var
  a: Integer;
begin
  if TargetCanvas.TextWidth(s) < TextSpace then begin
    Result := s;
  end else begin
    a := Length(s) - 1;
    while (a > 0) and (TargetCanvas.TextWidth('...' + Copy(s, a, Length(s) - a + 1)) < TextSpace) do
      Dec(a);
    Inc(a);
    Result := '...' + Copy(s, a, Length(s) - a + 1);
  end;
  Done := True;
end;

procedure TMainForm.VirtualStringTreeStopsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if FCurrentStopObject is TRank then
    DragObject := TOrganDragObject.Create(FCurrentStopObject);
end;

procedure TMainForm.VirtualStringTreeStopsDblClick(Sender: TObject);
begin
  if Assigned(FCurrentStopObject) and (FCurrentStopObject is TRank) then
    ListenForm.Execute(FCurrentStopObject as TRank);
end;

procedure TMainForm.ButtonDeleteStopClick(Sender: TObject);
begin
  if Assigned(FCurrentStopObject) then begin
    if FCurrentStopObject is TStop then begin
      FOrgan.RemoveStop(FCurrentStopObject as TStop);
      FOrgan.MarkModified;
      FCurrentStopObject := nil;
      FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
    end;
    if FCurrentStopObject is TRank then begin
      (FCurrentStopObject as TRank).Stop.RemoveRank(FCurrentStopObject as TRank);
      FOrgan.MarkModified;
      FDataSync := FDataSync - [dsStopStructure, dsRankStructure];
    end;
  end;
  UpdateGUI;
end;

procedure TMainForm.ButtonRemoveRankClick(Sender: TObject);
var
  e: TVTVirtualNodeEnumerator;
  p: POrganNode;
begin
  e := VirtualStringTreeRanks.SelectedNodes(True).GetEnumerator;
  try
    while e.MoveNext do begin
      p := VirtualStringTreeRanks.GetNodeData(e.Current);
      if Assigned(p) then begin
        FOrgan.RemoveRank(p.Data as TRank);
        FOrgan.MarkModified;
      end;
    end;
  finally
    e.Destroy;
  end;
  FCurrentRankObject := nil;
  FDataSync := FDataSync - [dsRankStructure];
  UpdateGUI;
end;

procedure TMainForm.VirtualStringTreeRanksKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: ButtonListenRankClick(nil);
    VK_DELETE: ButtonRemoveRankClick(nil);
    Ord('A'): if ssCtrl in Shift then VirtualStringTreeRanks.SelectAll(False);
  end;
end;

procedure TMainForm.ButtonClearRanksClick(Sender: TObject);
var
  e: TVTVirtualNodeEnumerator;
  p: POrganNode;
begin
  e := VirtualStringTreeRanks.Nodes(True).GetEnumerator;
  try
    while e.MoveNext do begin
      p := VirtualStringTreeRanks.GetNodeData(e.Current);
      if Assigned(p) then begin
        FOrgan.RemoveRank(p.Data as TRank);
        FOrgan.MarkModified;
      end;
    end;
  finally
    e.Destroy;
  end;
  FCurrentRankObject := nil;
  FDataSync := FDataSync - [dsRankStructure];
  UpdateGUI;
end;

procedure TMainForm.VirtualStringTreeStopsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE: ButtonDeleteStopClick(nil);
  end;
end;

procedure TMainForm.VirtualStringTreeButtonsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '';
  with POrganNode(Sender.GetNodeData(Node))^ do begin
    if Data is TManual then
      with Data as TManual do
        CellText := Name + ' (' + S_Division + ')';
    if Data is TStopFamily then
      with Data as TStopFamily do
        CellText := Name + ' (' + S_StopFamily + ')';
    if Data is TManualCouplers then
      CellText := S_Couplers;
    if Data is TStop then
      with Data as TStop do
        CellText := Name + ' (' + S_Stop + ')';
    if Data is TCoupler then
      with Data as TCoupler do
        CellText := Name + ' (' + S_Coupler + ')';
    if Data is TPiston then
      with Data as TPiston do
        CellText := StopFamily.Name + ' (' + S_Piston + ')';
    if Data is TTremulant then
      with Data as TTremulant do
        CellText := Manual.Name + ' (' + S_Tremulant + ')';
  end;
end;

procedure TMainForm.VirtualStringTreeButtonsMeasureItem(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  var NodeHeight: Integer);
begin
  NodeHeight := 18;
  with POrganNode(Sender.GetNodeData(Node))^ do begin
    if Data is TManual then
      NodeHeight := ImageListLarge.Height + 2;
    if Data is TStopFamily then
      NodeHeight := ImageListLarge.Height + 2;
    if Data is TManualCouplers then
      NodeHeight := ImageListLarge.Height + 2;
  end;
end;

procedure TMainForm.VirtualStringTreeButtonsGetImageIndexEx(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer;
  var ImageList: TCustomImageList);
begin
  with POrganNode(Sender.GetNodeData(Node))^ do begin
    if Data is TManual then begin
      ImageList := ImageListLarge;
      ImageIndex := 0;
    end;
    if Data is TStopFamily then begin
      ImageList := ImageListLarge;
      ImageIndex := 2;
    end;
    if Data is TManualCouplers then begin
      ImageList := ImageListLarge;
      ImageIndex := 3;
    end;
    if Data is TStop then begin
      ImageList := ImageListSmall;
      ImageIndex := 1;
    end;
    if Data is TCoupler then begin
      ImageList := ImageListSmall;
      ImageIndex := 2;
    end;
    if Data is TPiston then begin
      ImageList := ImageListSmall;
      ImageIndex := 3;
    end;
    if Data is TTremulant then begin
      ImageList := ImageListSmall;
      ImageIndex := 4;
    end;
  end;
end;

procedure TMainForm.VirtualStringTreeStopsGetImageIndexEx(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer;
  var ImageList: TCustomImageList);
begin
  with POrganNode(Sender.GetNodeData(Node))^ do begin
    if Data is TManual then begin
      ImageList := ImageListLarge;
      ImageIndex := 0;
    end;
    if Data is TStop then begin
      ImageList := ImageListSmall;
      ImageIndex := 0;
    end;
    if Data is TRank then begin
      ImageList := ImageListWave;
      ImageIndex := 0;
    end;
  end;
end;

procedure TMainForm.VirtualStringTreeRanksGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    ImageIndex := 0;
end;

procedure TMainForm.VirtualStringTreeCouplersAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);

  function GetWineAvail: boolean;
  var H: cardinal;
  begin
   Result := False;
   H := LoadLibrary('ntdll.dll');
   if H > HINSTANCE_ERROR then
   begin
     Result := Assigned(GetProcAddress(H, 'wine_get_version'));
     FreeLibrary(H);
   end;
  end;

  procedure DrawCheckBox(Sender: TVirtualStringTree; const Canvas: TCanvas; const Rect: TRect; const Checked: Boolean);
  var
    Details: TThemedElementDetails;
    X, Y: Integer;
    R: TRect;
    NonThemedCheckBoxState: Cardinal;
  const
    CHECKBOX_SIZE = 13;
  begin
    if ThemeServices.ThemesEnabled and not GetWineAvail then begin
      if Checked then
        Details := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
      else
        Details := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal);
      X := Rect.Left + (Rect.Right - Rect.Left - CHECKBOX_SIZE) div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top - CHECKBOX_SIZE) div 2;
      R := Classes.Rect(X, Y, X + CHECKBOX_SIZE, Y + CHECKBOX_SIZE);
      ThemeServices.DrawElement(Canvas.Handle, Details, R);
    end else begin
      Canvas.FillRect(Rect);
      NonThemedCheckBoxState := DFCS_BUTTONCHECK;
      if Checked then
        NonThemedCheckBoxState := NonThemedCheckBoxState or DFCS_CHECKED;
      X := Rect.Left + (Rect.Right - Rect.Left - CHECKBOX_SIZE) div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top - CHECKBOX_SIZE) div 2;
      R := Classes.Rect(X, Y, X + CHECKBOX_SIZE, Y + CHECKBOX_SIZE);
      DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, NonThemedCheckBoxState);
    end;
  end;
                               
begin
  if (Column > 0) and (FCurrentOrganObject is TManual) then
    with POrganNode(Sender.GetNodeData(Node))^ do
      DrawCheckBox(Sender as TVirtualStringTree, TargetCanvas, CellRect, FOrgan.Couplers[FCurrentOrganObject as TManual, Data as TManual, TCouplerDelta(Column - 1)].Active);
end;

procedure TMainForm.VirtualStringTreeCouplersNodeClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
begin
  if (HitInfo.HitColumn in [1 .. 3]) and (FCurrentOrganObject is TManual) then begin
    with POrganNode(Sender.GetNodeData(HitInfo.HitNode))^ do
      with FOrgan.Couplers[FCurrentOrganObject as TManual, Data as TManual, TCouplerDelta(HitInfo.HitColumn - 1)] do
        Active := not Active;
    FOrgan.MarkModified;
    FDataSync := FDataSync - [dsStopStructure, dsPanelStructure];
    UpdateGUI;
  end;
end;

procedure TMainForm.VirtualStringTreeCouplersGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    0: CellText := (POrganNode(Sender.GetNodeData(Node)).Data as TManual).Name;
  else
    CellText := ' '
  end;
end;

procedure TMainForm.VirtualStringTreeButtonsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if (FCurrentButtonObject is TStop) or (FCurrentButtonObject is TCoupler) or (FCurrentButtonObject is TPiston) or (FCurrentButtonObject is TTremulant) then
    DragObject := TOrganDragObject.Create(FCurrentButtonObject);
end;

procedure TMainForm.MenuItemExportClick(Sender: TObject);
begin
  if FOrgan.ExportFilename <> '' then begin
    SaveDialogExport.FileName := ExtractFileName(FOrgan.ExportFilename);
    SaveDialogExport.InitialDir := ExtractFilePath(FOrgan.ExportFilename);
  end else begin
    if FOrgan.Filename <> '' then begin
      SaveDialogExport.FileName := ChangeFileExt(ExtractFileName(FOrgan.Filename), '.organ');
      SaveDialogExport.InitialDir := ExtractFilePath(FOrgan.Filename);
    end else begin
      SaveDialogExport.FileName := '';
      SaveDialogExport.InitialDir := '';
    end;
  end;
  if SaveDialogExport.Execute then begin
    FOrgan.Inspect(SaveDialogExport.FileName);
    WarningForm.Execute(FOrgan);
    ExportForm.Execute(FOrgan, SaveDialogExport.FileName);
  end;
  UpdateGUI;
end;

procedure TMainForm.ButtonInfoFilenameClick(Sender: TObject);
begin
  if OpenDialogInfoFilename.Execute then begin
    EditInfoFilename.Text := OpenDialogInfoFilename.Filename;
    UpdateData;
  end;
end;

procedure TMainForm.MenuItemNewClick(Sender: TObject);
begin
  if QuerySaveFile then begin
    FOrgan.Clear;
    ResetGUI(True);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := QuerySaveFile;
end;

function TMainForm.QuerySaveFile: Boolean;
var
  s: string;
begin
  if FOrgan.Modified then begin
    s := FOrgan.Filename;
    if s = '' then
      s := S_Untitled;
    case MessageBox(Handle, PChar(Format(S_ProjectModifiedQuerySaveChanges, [s])), PChar(S_Confirmation), MB_ICONQUESTION or MB_YESNOCANCEL) of
      ID_YES: begin
        if FOrgan.Filename = '' then begin
          Result := SaveDialogProject.Execute;
          if Result then begin
            FOrgan.SaveToFile(SaveDialogProject.FileName, ConfigurationForm.StoreRelativePaths);
            ConfigurationForm.AddToRecents(FOrgan.Filename);
            UpdateGUI;
          end;
        end else begin
          Result := True;
          FOrgan.SaveToFile(ConfigurationForm.StoreRelativePaths);
          ConfigurationForm.AddToRecents(FOrgan.Filename);
          UpdateGUI;
        end;
      end;
      ID_NO: Result := True;
    else
      Result := False;
    end;
  end else begin
    Result := True;
    ConfigurationForm.AddToRecents(FOrgan.Filename);
  end;
end;

procedure TMainForm.MenuItemOpenClick(Sender: TObject);
begin
  if QuerySaveFile and OpenDialogProject.Execute then begin
    FOrgan.LoadFromFile(OpenDialogProject.FileName);
    ConfigurationForm.AddToRecents(FOrgan.Filename);
    ResetGUI(True);
  end;
end;

procedure TMainForm.ResetGUI(ResetTab: Boolean);
begin
  FCurrentOrganObject := nil;
  FCurrentStopObject := nil;
  FCurrentRankObject := nil;
  FDataSync := [];
  if ResetTab then
    PageControlMain.ActivePageIndex := 0;
  UpdateGUI;
end;

procedure TMainForm.MenuItemSaveClick(Sender: TObject);
begin
  if FOrgan.Filename = '' then begin
    if SaveDialogProject.Execute then
      FOrgan.SaveToFile(SaveDialogProject.FileName, ConfigurationForm.StoreRelativePaths);
  end else
    FOrgan.SaveToFile(ConfigurationForm.StoreRelativePaths);
  ConfigurationForm.AddToRecents(FOrgan.Filename);
  UpdateGUI;
end;

procedure TMainForm.MenuItemSaveAsClick(Sender: TObject);
begin
  if FOrgan.Filename <> '' then begin
    SaveDialogProject.FileName := ExtractFileName(FOrgan.Filename);
    SaveDialogProject.InitialDir := ExtractFilePath(FOrgan.Filename);
  end;
  if SaveDialogProject.Execute then
    FOrgan.SaveToFile(SaveDialogProject.FileName, ConfigurationForm.StoreRelativePaths);
  ConfigurationForm.AddToRecents(FOrgan.Filename);
  UpdateGUI;
end;

procedure TMainForm.MenuItemExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if not (csReading in ComponentState) then begin
    if GroupBoxOrganStructure.Width > TabSheetOrganStructure.ClientWidth - SplitterOrganStructure.MinSize - 4 then
      GroupBoxOrganStructure.Width := TabSheetOrganStructure.ClientWidth - SplitterOrganStructure.MinSize - 4;
    if GroupboxRanks.Width > TabSheetWaveSamples.ClientWidth - SplitterWaveSamples.MinSize - 4 then
      GroupboxRanks.Width := TabSheetWaveSamples.ClientWidth - SplitterWaveSamples.MinSize - 4;
    if PanelPanelLayout.Width > TabSheetPanelLayout.ClientWidth - SplitterStopLayout.MinSize - 4 then
      PanelPanelLayout.Width := TabSheetPanelLayout.ClientWidth - SplitterStopLayout.MinSize - 4;
  end;
  if not IsZoomed(Handle) and not IsIconic(Handle) then begin
    FNormalPosition := Point(Left, Top);
    FNormalSize.cx := ClientWidth;
    FNormalSize.cy := ClientHeight;
  end;
end;

function TMainForm.IsNodeVisible(Tree: TVirtualStringTree;
  Node: PVirtualNode): Boolean;
var
  r: TRect;
begin
  r := Tree.GetDisplayRect(Node, - 1, False);
  Result := (r.Top >=0) and (r.Bottom < Tree.ClientHeight);
end;

function TMainForm.BrowseForFolder(var Path: string): Boolean;
var
  BI: TBrowseInfo;
  p: PItemIDList;
  s, t: string;
const
  BIF_NONEWFOLDERBUTTON = $00000200;
begin
  Result := False;
  ZeroMemory(@BI,SizeOf(BI));
  SetLength(t,MAX_PATH);
  with BI do begin
    hwndOwner := Handle;
    pidlRoot := nil;
    pszDisplayName := PChar(t);
    lpszTitle := PChar(S_SelectPathToExplore);
    ulFlags := BIF_NEWDIALOGSTYLE or BIF_NONEWFOLDERBUTTON or BIF_RETURNONLYFSDIRS or BIF_VALIDATE;
  end;
  p := SHBrowseForFolder(BI);
  if Assigned(p) then
    try
      SetLength(s, MAX_PATH);
      if SHGetPathFromIDList(p, PChar(s)) then begin
        Result := True;
        Path := PChar(s);
      end;
    finally
      CoTaskMemFree(p);
    end;
end;

procedure TMainForm.ButtonAddRanksClick(Sender: TObject);
var
  s: string;
begin
  if BrowseForFolder(s) then begin
    ScanForm.Execute(FOrgan, s);
    FOrgan.MarkModified;
    Exclude(FDataSync, dsRankStructure);
    UpdateGUI;
  end;
end;

procedure TMainForm.GenericComboBoxDrawItemImage(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do begin
    Canvas.FillRect(Rect);
    Rect.Left := Rect.Left + (Rect.Right - Rect.Left - TImageList(Tag).Width) div 2;
//    if Rect.Left < 3 then
//      Rect.Left := 3;
    if Enabled then begin
      Rect.Top := Rect.Top + (Rect.Bottom - Rect.Top - TImageList(Tag).Height) div 2;
      Rect.Right := Rect.Left + TImageList(Tag).Width;
      Rect.Bottom := Rect.Top + TImageList(Tag).Height;
      if TImageList(Tag).Tag = 0 then begin
        Canvas.Brush.Color := clWhite;
        Canvas.FillRect(Rect);
      end;
      TImageList(Tag).Draw(Canvas, Rect.Left, Rect.Top, Index);
    end;
  end;
end;

procedure TMainForm.PaintBoxStopFamilyExamplePaint(Sender: TObject);
var
  p: TBitmap;
  a, b, c, d: Integer;
  r: TRect;
  FontName: string;
  FontColor: TColor;
  DrawstopFontSize: Integer;
  PistonsFontSize: Integer;
  DrawstopImage: Integer;
  PistonImage: Integer;

  procedure AdjustText(s: string; x1, x2, y1, y2, Delta: Integer);
  begin
    r := Rect(x1 + Delta, 0, x2 - Delta, 0);
    DrawText(p.Canvas.Handle, PChar(s), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS or DT_EDITCONTROL or DT_CALCRECT);
    if r.Bottom - r.Top > y2 - y1 then
      r.Bottom := r.Top + y2 - y1;
    a := y1 + ((y2 - y1) - (r.Bottom - r.Top)) div 2;
    b := a + r.Bottom - r.Top;
    r := Rect(x1 + Delta, a, x2 - Delta, b);
    DrawText(p.Canvas.Handle, PChar(s), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS or DT_EDITCONTROL);
  end;

  procedure AdjustImage(x, y, w, h, dx, dy: Integer);
  begin
    (Sender as TPaintBox).Canvas.CopyRect(Rect(dx + x, dy + y, dx + x + w, dy + y + h), p.Canvas, Rect(x, y, x + w, y + h));
  end;

begin
  FontName := '';
  if (FCurrentOrganObject is TStopFamily) or (FCurrentOrganObject is TCouplers) or (FCurrentOrganObject is TTremulants) then begin
    if FCurrentOrganObject is TStopFamily then begin
      FontName := TStopFamily(FCurrentOrganObject).FontName;
      FontColor := TStopFamily(FCurrentOrganObject).RGBFontColor;
      DrawstopFontSize := TStopFamily(FCurrentOrganObject).DrawstopFontSize;
      PistonsFontSize := TStopFamily(FCurrentOrganObject).PistonFontSize;
      DrawstopImage := TStopFamily(FCurrentOrganObject).DrawstopImage;
      PistonImage := TStopFamily(FCurrentOrganObject).PistonImage;
    end else begin
      if FCurrentOrganObject is TTremulants then begin
        FontName := FOrgan.Tremulants.FontName;
        FontColor := FOrgan.Tremulants.RGBFontColor;
        DrawstopFontSize := FOrgan.Tremulants.DrawstopFontSize;
        PistonsFontSize := FOrgan.Tremulants.PistonFontSize;
        DrawstopImage := FOrgan.Tremulants.DrawstopImage;
        PistonImage := FOrgan.Tremulants.PistonImage;
      end else begin
        FontName := FOrgan.Couplers.FontName;
        FontColor := FOrgan.Couplers.RGBFontColor;
        DrawstopFontSize := FOrgan.Couplers.DrawstopFontSize;
        PistonsFontSize := FOrgan.Couplers.PistonFontSize;
        DrawstopImage := FOrgan.Couplers.DrawstopImage;
        PistonImage := FOrgan.Couplers.PistonImage;
      end;
    end;
    p := TBitmap.Create;
    try
      p.Width := 2 * ImageListDrawstops.Width;
      p.Height := ImageListDrawstops.Height + ImageListPistons.Height;
      p.Canvas.FillRect(Rect(0, 0, p.Width, p.Height));
      p.Canvas.Brush.Style := bsClear;
      p.Canvas.Font.Name := FontName;
      p.Canvas.Font.Color := FontColor;
      p.Canvas.Font.Size := DrawstopFontSize;
      ImageListDrawstops.Draw(p.Canvas, 0, 0, DrawstopImage);
      ImageListPistons.Draw(p.Canvas, 0, ImageListDrawstops.Height, PistonImage);
      AdjustText(S_DrawstopOff, 0, ImageListDrawstops.Width div 2, 0, ImageListDrawstops.Height, 3);
      AdjustText(S_DrawstopOn, ImageListDrawstops.Width div 2, ImageListDrawstops.Width, 0, ImageListDrawstops.Height, 3);
      p.Canvas.Font.Size := PistonsFontSize;
      AdjustText(S_PistonOff, 0, ImageListPistons.Width div 2, ImageListDrawstops.Height, ImageListDrawstops.Height + ImageListPistons.Height, 3);
      AdjustText(S_PistonOn, ImageListPistons.Width div 2, ImageListPistons.Width, ImageListDrawstops.Height, ImageListDrawstops.Height + ImageListPistons.Height, 3);
      with Sender as TPaintBox do begin
        c := (Width - ImageListDrawstops.Width) div 3;
        d := (Height - (ImageListDrawstops.Width + ImageListPistons.Width) div 2) div 3;
        a := ImageListDrawstops.Width + c;
        b := ImageListDrawstops.Height + ImageListPistons.Height + d;
        a := (Width - a) div 2;
        b := (Height - b) div 2;
        AdjustImage(0, 0, ImageListDrawstops.Width div 2, ImageListDrawstops.Height, a, b);
        AdjustImage(ImageListDrawstops.Width div 2, 0, ImageListDrawstops.Width div 2, ImageListDrawstops.Height, a + c, b);
        AdjustImage(0, ImageListDrawstops.Height, ImageListPistons.Width div 2, ImageListPistons.Height, a + (ImageListDrawstops.Width - ImageListPistons.Width) div 4, b + d);
        AdjustImage(ImageListPistons.Width div 2, ImageListDrawstops.Height, ImageListPistons.Width div 2, ImageListPistons.Height, a + 3 * (ImageListDrawstops.Width - ImageListPistons.Width) div 4 + c, b + d);
      end;
    finally
      p.Destroy;
    end;
  end;
end;

procedure TMainForm.PaintBoxMainPanelPreviewPaint(Sender: TObject);
var
  a, b, c, d, e: Integer;
  p, q: TBitmap;
  r: TRect;

  procedure TileFillRect(Index: Integer; x, y, w, h: Integer);
  var
    a, b, c, d: Integer;
  begin
    ImageListWoods.Draw(q.Canvas, 0, 0, Index);
    a := 0;
    while a < w do begin
      b := 0;
      if a + q.Width > w then
        c := w - a
      else
        c := q.Width;
      while b < h do begin
        if b + q.Height > h then
          d := h - b
        else
          d := q.Height;
        p.Canvas.CopyRect(Rect(x + a, y + b, x + a + c, y + b + d), q.Canvas, Rect(0, 0, c, d));
        Inc(b, q.Height);
      end;
      Inc(a, q.Width);
    end;
  end;

  procedure AdjustText(s: string; x1, x2, y1, y2, Delta: Integer);
  begin
    r := Rect(x1 + Delta, 0, x2 - Delta, 0);
    DrawText(p.Canvas.Handle, PChar(s), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS or DT_EDITCONTROL or DT_CALCRECT);
    if r.Bottom - r.Top > y2 - y1 then
      r.Bottom := r.Top + y2 - y1;
    a := y1 + ((y2 - y1) - (r.Bottom - r.Top)) div 2;
    b := a + r.Bottom - r.Top;
    r := Rect(x1 + Delta, a, x2 - Delta, b);
    DrawText(p.Canvas.Handle, PChar(s), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS or DT_EDITCONTROL);
  end;

begin
  p := TBitmap.Create;
  q := TBitmap.Create;
  try
    p.Width := PaintBoxMainPanelPreview.Width;
    p.Height := PaintBoxMainPanelPreview.Height;
    q.Width := ImageListWoods.Width;
    q.Height := ImageListWoods.Height;
    SetLength(FMainPanelAreas, 12);
    b := (p.Width - ImageListKeyboard.Width) div 6;
    a := (p.Width - ImageListKeyboard.Width - 2 * b) div 2;
    b := a + ImageListKeyboard.Width + 2 * b;
    c := 2 * (p.Height - 4 * ImageListKeyboard.Height - 2 * ImageListPedalboard.Height) div 3;
    d :=p.Height - 2 * ImageListPedalboard.Height;
    FMainPanelAreas[0].Index := 0;
    FMainPanelAreas[0].Rect := Rect(0, 0, a, p.Height);
    FMainPanelAreas[1].Index := 0;
    FMainPanelAreas[1].Rect := Rect(b, 0, p.Width, p.Height);
    FMainPanelAreas[2].Index := 1;
    FMainPanelAreas[2].Rect := Rect(a, 0, b, c);
    FMainPanelAreas[3].Index := 3;
    FMainPanelAreas[3].Rect := Rect(a, c, b, c + ImageListKeyboard.Height);
    FMainPanelAreas[4].Index := 2;
    FMainPanelAreas[4].Rect := Rect(a, c + ImageListKeyboard.Height, b, c + 2 * ImageListKeyboard.Height);
    FMainPanelAreas[5].Index := 3;
    FMainPanelAreas[5].Rect := Rect(a, c + 2 * ImageListKeyboard.Height, b, c + 3 * ImageListKeyboard.Height);
    FMainPanelAreas[6].Index := 2;
    FMainPanelAreas[6].Rect := Rect(a, c + 3 * ImageListKeyboard.Height, b, c + 4 * ImageListKeyboard.Height);
    FMainPanelAreas[7].Index := 1;
    FMainPanelAreas[7].Rect := Rect(a, c + 4 * ImageListKeyboard.Height, b, d);
    FMainPanelAreas[8].Index := 2;
    FMainPanelAreas[8].Rect := Rect(a, d, b, d + ImageListPedalboard.Height);
    FMainPanelAreas[9].Index := 3;
    FMainPanelAreas[9].Rect := Rect(a, d + ImageListPedalboard.Height, b, d + 2 * ImageListPedalboard.Height);
    FMainPanelAreas[10].Index := 4;
    FMainPanelAreas[10].Rect := Rect(b + a div 7, c div 6, b + 3 * a div 7, p.Height - c div 6);
    FMainPanelAreas[11].Index := 4;
    FMainPanelAreas[11].Rect := Rect(b + 4 * a div 7, c div 6, b + 6 * a div 7, p.Height - c div 6);
    for e := 0 to 11 do
      with FMainPanelAreas[e] do
        TileFillRect(FOrgan.Layout.BackgroundImage[Index], Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
    ImageListKeyboard.Draw(p.Canvas, (a + b - ImageListKeyboard.Width) div 2, c, 0);
    ImageListKeyboard.Draw(p.Canvas, (a + b - ImageListKeyboard.Width) div 2, c + 2 * ImageListKeyboard.Height, 0);
    ImageListPedalboard.Draw(p.Canvas, (a + b - ImageListPedalboard.Width) div 2, d + ImageListPedalboard.Height, 0);
    p.Canvas.Brush.Style := bsClear;
    p.Canvas.Font.Name := FOrgan.Layout.Labels.FontName;
    p.Canvas.Font.Color := FOrgan.Layout.Labels.RGBFontColor;
    p.Canvas.Font.Size := FOrgan.Layout.Labels.FontSize;
    a := (p.Width - ImageListLabels.Width) div 2;
    b := (c - ImageListLabels.Height) div 2;
    ImageListLabels.Draw(p.Canvas, a, b, FOrgan.Layout.Labels.Image);
    AdjustText(S_Example, a, a + ImageListLabels.Width, b, b + ImageListLabels.Height, 3);
    r := Rect(0, 0, p.Width, p.Height);
    DrawEdge(p.Canvas.Handle, r, EDGE_SUNKEN, BF_RECT or BF_SOFT);
    PaintBoxMainPanelPreview.Canvas.Draw(0, 0, p);
  finally
    q.Destroy;
    p.Destroy;
  end;
end;

procedure TMainForm.PaintBoxMainPanelPreviewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  a, b: Integer;
begin
  b := - 1;
  for a := Low(FMainPanelAreas) to High(FMainPanelAreas) do
    if PtInRect(FMainPanelAreas[a].Rect, Point(X, Y)) then
      b := FMainPanelAreas[a].Index;
  if b in [0 .. 4] then begin
    a := FOrgan.Layout.BackgroundImage[b];
    if WoodForm.Execute(a, S_BackgroundNames[b]) then begin
      FOrgan.Layout.BackgroundImage[b] := a;
      FOrgan.MarkModified;
      UpdateGUI;
    end;
  end;
end;

procedure TMainForm.PanelMainPanelPreviewWindowProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_MOUSELEAVE: begin
      FPanelMainPanelPreviewTracking := False;
      GroupBoxMainPanelPreview.Caption := S_BackgroundImages;
    end;
  else
    FPanelMainPanelPreviewWindowProc(Message);
  end;
end;

procedure TMainForm.PaintBoxMainPanelPreviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  TME: TTrackMouseEvent;
  a, b: Integer;
begin
  if not FPanelMainPanelPreviewTracking then begin
    TME.cbSize := SizeOf(TME);
    TME.dwFlags := TME_LEAVE;
    TME.hwndTrack := PanelMainPanelPreview.Handle;
    TME.dwHoverTime := 0;
    if not TrackMouseEvent(TME) then
      RaiseLastOSError;
  end;
  b := - 1;
  for a := Low(FMainPanelAreas) to High(FMainPanelAreas) do
    if PtInRect(FMainPanelAreas[a].Rect, Point(X, Y)) then
      b := FMainPanelAreas[a].Index;
  case b of
    0 .. 4: GroupBoxMainPanelPreview.Caption := Format(S_NamedBackgroundImageToEdit, [S_BackgroundNames[b]]);
  else
    GroupBoxMainPanelPreview.Caption := S_BackgroundImages;
  end;
end;

procedure TMainForm.VirtualStringTreeRanksDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
  var Effect: Integer; Mode: TDropMode);
var
  l: TStringList;

  procedure GetFileListFromObj(const DataObj: IDataObject);
  var
    FmtEtc: TFormatEtc;         // specifies required data format
    Medium: TStgMedium;         // storage medium containing file list
    DroppedFileCount: Integer;  // number of dropped files
    I: Integer;                 // loops thru dropped files
    FilenameLength: Integer;    // length of a dropped file name
    Filename: string;           // name of a dropped file
  begin
    // Get required storage medium from data object
    FmtEtc.cfFormat := CF_HDROP;
    FmtEtc.ptd := nil;
    FmtEtc.dwAspect := DVASPECT_CONTENT;
    FmtEtc.lindex := -1;
    FmtEtc.tymed := TYMED_HGLOBAL;
    OleCheck(DataObj.GetData(FmtEtc, Medium));
    try
      try
        // Get count of files dropped
        DroppedFileCount := DragQueryFile(Medium.hGlobal, $FFFFFFFF, nil, 0);
        // Get name of each file dropped and process it
        for I := 0 to Pred(DroppedFileCount) do
        begin
          // get length of file name, then name itself
          FilenameLength := DragQueryFile(Medium.hGlobal, I, nil, 0);
          SetLength(Filename, FilenameLength);
          DragQueryFile(
            Medium.hGlobal, I, PChar(Filename), FilenameLength + 1
          );
          // add file name to list
          l.Add(Filename);
        end;
      finally
        // Tidy up - release the drop handle
        // don't use DropH again after this
        DragFinish(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;

begin
  if Assigned(DataObject) then begin
    l := TStringList.Create;
    try
      GetFileListFromObj(DataObject);
      if l.Count > 0 then begin
        ScanForm.Execute(FOrgan, l);
        FOrgan.MarkModified;
        Exclude(FDataSync, dsRankStructure);
        UpdateGUI;
      end;
    finally
      l.Destroy;
    end;
  end;
end;

procedure TMainForm.VirtualStringTreeRanksDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
  Effect := DROPEFFECT_LINK;
  Accept := True;
end;

procedure TMainForm.MenuItemInspectClick(Sender: TObject);
begin
  FOrgan.Inspect('');
  if FOrgan.Warnings.Count = 0 then
    MessageBox(Handle, PChar(S_NoProblemDetected), PChar(S_Information), MB_ICONINFORMATION)
  else
    WarningForm.Execute(FOrgan);
end;

procedure TMainForm.PaintBoxEnclosuresExamplePaint(Sender: TObject);
var
  r: TRect;
begin
  with PaintBoxEnclosuresExample, PaintBoxEnclosuresExample.Canvas do begin
    Brush.Style := bsClear;
    Font.Name := FOrgan.Enclosures.FontName;
    Font.Color := FOrgan.Enclosures.RGBFontColor;
    Font.Size := FOrgan.Enclosures.FontSize;
    r.Left := (Width - ImageListEnclosures.Width) div 2;
    r.Right := r.Left + ImageListEnclosures.Width;
    r.Top := (Height - ImageListEnclosures.Height) div 2;
    r.Bottom := r.Top + ImageListEnclosures.Height;
    ImageListEnclosures.Draw(Canvas, r.Left, r.Top, FOrgan.Enclosures.Image);
    DrawText(Handle, PChar(S_Example), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_EDITCONTROL);
  end;
end;

procedure TMainForm.Initialize;
begin
  FOrgan := TOrgan.Create;
  VirtualStringTreeStops.NodeDataSize := SizeOf(TOrganNode);
  VirtualStringTreeRanks.NodeDataSize := SizeOf(TOrganNode);
  VirtualStringTreeButtons.NodeDataSize := SizeOf(TOrganNode);
  ObjectMatrixFrameMainPanelLeftStopjamb.Matrix := FOrgan.Layout.LeftMatrix;
  ObjectMatrixFrameMainPanelLeftStopjamb.TopLabels := FOrgan.Layout.Labels.TopLeftLabels;
  ObjectMatrixFrameMainPanelLeftStopjamb.BottomLabels := FOrgan.Layout.Labels.BottomLeftLabels;
  ObjectMatrixFrameMainPanelRightStopjamb.Matrix := FOrgan.Layout.RightMatrix;
  ObjectMatrixFrameMainPanelRightStopjamb.TopLabels := FOrgan.Layout.Labels.TopRightLabels;
  ObjectMatrixFrameMainPanelRightStopjamb.BottomLabels := FOrgan.Layout.Labels.BottomRightLabels;
  ObjectMatrixFrameMainPanelCenterStopjamb.Matrix := FOrgan.Layout.CenterMatrix;
  ObjectMatrixFrameMainPanelPistons.ItemWidth := 2 * ObjectMatrixFrameMainPanelPistons.ItemWidth div 3;
  ObjectMatrixFrameMainPanelPistons.Matrix := FOrgan.Layout.PistonMatrix;
  ObjectMatrixFrameMainPanelPistons.Organ := FOrgan;
  TreeViewOrganStructure.BevelEdges := [];
  TreeViewPanelStructure.BevelEdges := [];
  ComboBoxCouplersDrawstopImage.Tag := Integer(ImageListDrawstops);
  ComboBoxCouplersPistonImage.Tag := Integer(ImageListPistons);
  ComboBoxCouplersFontName.Items.AddStrings(Screen.Fonts);
  ComboBoxTremulantsDrawstopImage.Tag := Integer(ImageListDrawstops);
  ComboBoxTremulantsPistonImage.Tag := Integer(ImageListPistons);
  ComboBoxTremulantsFontName.Items.AddStrings(Screen.Fonts);
  ComboBoxEnclosuresImage.Tag := Integer(ImageListEnclosures);
  ComboBoxEnclosuresFontName.Items.AddStrings(Screen.Fonts);
  ComboBoxStopFamilyDrawstopImage.Tag := Integer(ImageListDrawstops);
  ComboBoxStopFamilyPistonImage.Tag := Integer(ImageListPistons);
  ComboBoxStopFamilyFontName.Items.AddStrings(Screen.Fonts);
  ComboBoxMainPanelLabelsImage.Tag := Integer(ImageListLabels);
  ComboBoxMainPanelLabelsFontName.Items.AddStrings(Screen.Fonts);
  FPanelMainPanelPreviewWindowProc := PanelMainPanelPreview.WindowProc;
  PanelMainPanelPreview.WindowProc := PanelMainPanelPreviewWindowProc;
  ComboBoxMainPanelLeftStopjambLayout.Tag := Integer(ImageListStopsLayout);
  ComboBoxMainPanelRightStopjambLayout.Tag := Integer(ImageListStopsLayout);
  ComboBoxMainPanelPistonsLayout.Tag := Integer(ImageListPistonsLayout);
  GroupBoxCouplersExample.DoubleBuffered := True;
  GroupBoxTremulantsExample.DoubleBuffered := True;
  GroupBoxEnclosuresExample.DoubleBuffered := True;
  GroupBoxStopFamilyExample.DoubleBuffered := True;
  GroupboxMainPanelPreview.DoubleBuffered := True;
  PanelMainPanelPreview.DoubleBuffered := True;
  ResetGUI(True);
  if ParamCount > 0 then
    try
      FOrgan.LoadFromFile(ParamStr(1));
      ConfigurationForm.AddToRecents(ParamStr(1));
      ResetGUI(True);
    except
      on e: Exception do
        MessageBox(Handle, PChar(e.Message), nil, 0);
    end;
end;

procedure TMainForm.MenuItemSettingsClick(Sender: TObject);
begin
  ConfigurationForm.Execute;
end;

procedure TMainForm.MenuItemAboutClick(Sender: TObject);
begin
  SplashForm.Execute;
end;

procedure TMainForm.MenuItemFileClick(Sender: TObject);
var
  a: Integer;
  m: TMenuItem;
begin
  MenuItemReopen.Clear;
  for a := 0 to ConfigurationForm.Recents.Count - 1 do
    if ConfigurationForm.Recents[a] <> FOrgan.Filename then begin
      m := TMenuItem.Create(MenuitemReopen);
      m.Caption := ConfigurationForm.Recents[a];
      m.Hint := ConfigurationForm.Recents[a];
      m.OnClick := MenuItemRecentClick;
      MenuitemReopen.Add(m);
    end;
  MenuitemReopen.Enabled := MenuItemReopen.Count > 0;
end;

procedure TMainForm.MenuItemRecentClick(Sender: TObject);
begin
  if QuerySaveFile then
    with Sender as TMenuItem do begin
      FOrgan.LoadFromFile(Hint);
      ConfigurationForm.AddToRecents(FOrgan.Filename);
      ResetGUI(True);
    end;
end;

procedure TMainForm.WMPosChanged(var Message: TMessage);
begin
  inherited;
  FormResize(nil);
end;

procedure TMainForm.MenuItemHelpIndexClick(Sender: TObject);
begin
  ConfigurationForm.ShowHelp;
end;

end.
