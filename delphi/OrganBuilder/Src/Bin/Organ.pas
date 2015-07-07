unit Organ;

interface

uses
  Windows, SysUtils, Classes, Contnrs, Graphics, IniFiles, Forms, SyncObjs, Math;

var
  S_GeneratedUsingOrganBuilderVersion: string = 'Generated using Organ Builder v%s';
  S_Version: string = '';
  S_SomeFontsWereUnavailable: string = 'Some fonts were not available on your system and have been replaced by default fonts.';
  S_Warning: string = 'Warning';

  S_Warnings: array[0 .. 11] of string = (
    'Info HTML file [%s] cannot be made relative to the destination path.',
    'The specified width for the main panel (%s) might be too small.',
    'The specified height for the main panel (%s) might be too small.',
    'Pipe folder [%s] cannot be made relative to the destination path.',
    'Missing pipe loop sample file [%s].',
    'Missing pipe release sample file [%s].',
    'Stop "%s" (%s) is empty (no pipe rank assigned).',
    'Stop "%s" (%s) is part of family "%s" whose divisional ON/OFF piston has not been placed on the main panel.',
    'Stop "%s" (%s) has not been placed on the main panel.',
    'Tremulant of division "%s" has not been placed on the main panel.',
    '*** [%d warning(s) have been issued] ***',
    'The resulting GrandOrgue file may not work as expected.'
  );

  S_ManualNames: array[0 .. 5] of string = (
    'Pédalier',
    'Grand Orgue',
    'Positif',
    'Récit',
    'Écho',
    'Manual #%d'
  );

  S_StopFamilyNames: array[0 .. 2] of string = (
    'Fonds',
    'Anches',
    'Family #%d'
  );

type
  TOrgan = class;

  TCouplers = class;
  TTremulants = class;
  TEnclosures = class;

  TManual = class;
  TCoupler = class;
  TTremulant = class;
  TStopFamily = class;

  TPiston = class;
  TRank = class;
  TStop = class;

  TLayout = class;

  TObjectMatrix = class;   //delete

  TCouplerDelta = (cdMinus8, cdUnison, cdPlus8);
  TChannelAssignment = (caNone, caFront, caRear, caFrontLeft, caFrontRight, caRearLeft, caRearRight);

  TProjectFile = class(TMemIniFile)
  private
    FStoreRelativePaths: Boolean;
  public
    constructor Create(AFilename: string); overload;
    constructor Create(AFilename: string; AStoreRelativePaths: Boolean); overload;

    procedure WritePath(ASection, AKey, AValue: string);
    function ReadPath(ASection, AKey, ADefaultValue: string): string;
  end;

  TOrgan = class
  private
    FFilename: string;
    FModified: Boolean;

    FSection: TCriticalSection;
    FScanPath: string;
    FFoundRanks: Integer;
    FExportProgress: Double;
    FWarnings: TStrings;
    FFontWarning: Boolean;

    FManuals: TObjectList;
    FPedalboard: TManual;

    FCouplers: TCouplers;
    FTremulants: TTremulants;
    FEnclosures: TEnclosures;
    
    FStopFamilies: TObjectList;

    FPistons: TObjectList;
    FStops: TObjectList;
    FRanks: TObjectList;

    FInfos: array[0..6] of string;

    FLayout: TLayout;

    FExportFilename: string;
  protected
    function GetScanPath: string;
    function GetExportProgress: Double;
    procedure SetExportProgress(const Value: Double);

    function GetNumberOfManuals: Integer;
    procedure SetNumberOfManuals(const Value: Integer);
    function GetManual(const Index: Integer): TManual;  
    function GetHasPedals: Boolean;
    procedure SetHasPedals(const Value: Boolean);

    function GetNumberOfStopFamilies: Integer;
    procedure SetNumberOfStopFamilies(const Value: Integer);
    function GetStopFamily(const Index: Integer): TStopFamily;

    function GetPiston(AManual: TManual; AStopFamily: TStopFamily): TPiston;
    procedure UpdatePistons;
    function GetNumberOfRanks: Integer;
    function GetRank(const Index: Integer): TRank;
    function GetNumberOfStops: Integer;
    function GetStop(const Index: Integer): TStop;

    function GetInfo(const Index: Integer): string;
    procedure SetInfo(const Index: Integer; const Value: string);

    procedure SaveToFile(AFile: TProjectFile); overload;
    procedure LoadFromFile(AFile: TProjectFile); overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure MarkModified;
    procedure SaveToFile(AFilename: string; StoreRelativePaths: Boolean); overload;
    procedure SaveToFile(StoreRelativePaths: Boolean); overload;
    procedure LoadFromFile(AFilename: string); overload;
    procedure Export(AFilename: string; AInterrupt: PBoolean);

    procedure Inspect(AFilename: string);

    function IndexOfManual(AManual: TManual): Integer;

    function IndexOfStopFamily(AStopFamily: TStopFamily): Integer;

    procedure ScanFileSystem(ABasePath: string; AInterrupt: PBoolean);
    procedure RemoveRank(ARank: TRank);
    function AddStop(AName: string; AManual: TManual): TStop;
    procedure RemoveStop(AStop: TStop);

    property Filename: string read FFilename;
    property Modified: Boolean read FModified;

    property ScanPath: string read GetScanPath;
    property FoundRanks: Integer read FFoundRanks;
    property ExportProgress: Double read GetExportProgress;
    property Warnings: TStrings read FWarnings;

    property NumberOfManuals: Integer read GetNumberOfManuals write SetNumberOfManuals;
    property Manual[const Index: Integer]: TManual read GetManual;
    property HasPedals: Boolean read GetHasPedals write SetHasPedals;

    property Couplers: TCouplers read FCouplers;
    property Tremulants: TTremulants read FTremulants;
    property Enclosures: TEnclosures read FEnclosures;

    property NumberOfStopFamilies: Integer read GetNumberOfStopFamilies write SetNumberOfStopFamilies;
    property StopFamily[const Index: Integer]: TStopFamily read GetStopFamily;

    property Piston[Manual: TManual; Family: TStopFamily]: TPiston read GetPiston;
    property NumberOfRanks: Integer read GetNumberOfRanks;
    property Rank[const Index: Integer]: TRank read GetRank;
    property NumberOfStops: Integer read GetNumberOfStops;
    property Stop[const Index: Integer]: TStop read GetStop;

    property Layout: TLayout read FLayout;

    property Info[const Index: Integer]: string read GetInfo write SetInfo;
    property ChurchName: string index 0 read GetInfo write SetInfo;
    property ChurchAddress: string index 1 read GetInfo write SetInfo;
    property OrganBuilder: string index 2 read GetInfo write SetInfo;
    property OrganBuildDate: string index 3 read GetInfo write SetInfo;
    property OrganComments: string index 4 read GetInfo write SetInfo;
    property RecordingDetails: string index 5 read GetInfo write SetInfo;
    property InfoFilename: string index 6 read GetInfo write SetInfo;

    property ExportFilename: string read FExportFilename;
  end;

  TOrganObject = class
  private
    FOwner: TOrgan;
    FTag1, FTag2: Integer;
  public
    constructor Create(AOwner: TOrgan);

    property Owner: TOrgan read FOwner;

    property Tag1: Integer read FTag1 write FTag1;
    property Tag2: Integer read FTag2 write FTag2;
  end;

  TCaptionStyle = class(TOrganObject)
  private
    FFontName: string;
    FFontColor: Integer;
  protected
    procedure Clear; virtual; 

    procedure SaveToFile(AFile: TCustomIniFile; ASection: string; AName: string); virtual;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string; AName: string); virtual;

    function GetRGBFontColor: TColor;
    function GETODFFontColor: string;
  public
    property FontName: string read FFontName write FFontName;
    property FontColor: Integer read FFontColor write FFontColor;

    property RGBFontColor: TColor read GetRGBFontColor;
    property ODFFontColor: string read GETODFFontColor;
  end;

  TButtonStyle = class(TCaptionStyle)
  private
    FDrawstopImage: Integer;
    FPistonImage: Integer;
    FDrawstopFontSize: Integer;
    FPistonFontSize: Integer;
  protected
    procedure Clear; override;

    procedure SaveToFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
  public
    property DrawstopImage: Integer read FDrawstopImage write FDrawstopImage;
    property PistonImage: Integer read FPistonImage write FPistonImage;
    property DrawstopFontSize: Integer read FDrawstopFontSize write FDrawstopFontSize;
    property PistonFontSize: Integer read FPistonFontSize write FPistonFontSize;
  end;

  TCouplers = class(TButtonStyle)
  private
    FCouplers: TObjectList;
  protected
    procedure Clear; override;

    function GetCoupler(ASource, ADestination: TManual; ADelta: TCouplerDelta): TCoupler;
    procedure Update;
  public
    constructor Create(AOwner: TOrgan);
    destructor Destroy; override;

    property Coupler[ASource, ADestination: TManual; ADelta: TCouplerDelta]: TCoupler read GetCoupler; default;
  end;

  TTremulants = class(TButtonStyle)
  protected
    procedure Clear; override;
  end;

  TLabelStyle = class(TCaptionStyle)
  private
    FImage: Integer;
    FFontSize: Integer;
  protected
    procedure Clear; override;

    procedure SaveToFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
  public
    property Image: Integer read FImage write FImage;
    property FontSize: Integer read FFontSize write FFontSize;
  end;

  TEnclosures = class(TLabelStyle)
  protected
    procedure Clear; override;
  end;

  TManualCouplers = class(TOrganObject)

  end;

  TManual = class(TOrganObject)
  private
    FName: string;
    FAbbreviatedName: string;
    FComment: string;
    FNumberOfKeys: Integer;
    FFirstKey: Integer;
    FInvisible: Boolean;
    FStops: TList;
    FCouplers: TManualCouplers;

    FHasEnclosure: Boolean;
    FHasTremulant: Boolean;
    FEnclosureMinimumLevel: Integer;

    FTremulant: TTremulant;
    
    FAppearance: Integer;
  protected
    procedure SetInvisible(const Value: Boolean);

    function GetNumberOfStops: Integer;
    function GetStop(const Index: Integer): TStop;

    procedure SetHasTremulant(const Value: Boolean);
  public
    constructor Create(AOwner: TOrgan; Index: Integer);
    destructor Destroy; override;

    property Name: string read FName write FName;
    property AbbreviatedName: string read FAbbreviatedName write FAbbreviatedName;
    property Comment: string read FComment write FComment;
    property NumberOfKeys: Integer read FNumberOfKeys write FNumberOfKeys;
    property FirstKey: Integer read FFirstKey write FFirstKey;
    property Invisible: Boolean read FInvisible write SetInvisible;

    property NumberOfStops: Integer read GetNumberOfStops;
    property Stop[const Index: Integer]: TStop read GetStop;

    property Couplers: TManualCouplers read FCouplers;

    property HasEnclosure: Boolean read FHasEnclosure write FHasEnclosure;
    property EnclosureMinimumLevel: Integer read FEnclosureMinimumLevel write FEnclosureMinimumLevel;

    property HasTremulant: Boolean read FHasTremulant write SetHasTremulant;
    property Tremulant: TTremulant read FTremulant;

    property Appearance: Integer read FAppearance write FAppearance;
  end;

  TSwitch = class(TOrganObject)
  private
    FDisplayed, FPiston: Boolean;
    FPosition: TPoint;
  protected
    procedure UpdateLayout; virtual;
  end;

  TCoupler = class(TSwitch)
  private
    FSource, FDestination: TManual;
    FDelta: TCouplerDelta;
    FActive: Boolean;
  protected
    function GetName: string;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(AOwner: TOrgan; ASource, ADestination: TManual; ADelta: TCouplerDelta; AActive: Boolean);

    property Source: TManual read FSource;
    property Destination: TManual read FDestination;
    property Delta: TCouplerDelta read FDelta;
    property Active: Boolean read FActive write SetActive;

    property Name: string read GetName;
  end;

  TTremulant = class(TSwitch)
  private
    FManual: TManual;
    FPeriod: Integer;
    FStartRate: Integer;
    FStopRate: Integer;
    FAmpModDepth: Integer;
  protected
    function GetName: string;
  public
    constructor Create(AManual: TManual);

    property Manual: TManual read FManual;

    property Period: Integer read FPeriod write FPeriod;
    property StartRate: Integer read FStartRate write FStartRate;
    property StopRate: Integer read FStopRate write FStopRate;
    property AmpModDepth: Integer read FAmpModDepth write FAmpModDepth;

    property Name: string read GetName;
  end;

  TStopFamily = class(TButtonStyle)
  private
    FName: string;
    FHasPiston: Boolean;
  protected
    procedure SaveToFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string; AName: string); override;

    procedure SetHasPiston(const Value: Boolean);
  public
    constructor Create(AOwner: TOrgan; Index: Integer);

    property Name: string read FName write FName;
    property HasPiston: Boolean read FHasPiston write SetHasPiston;
  end;

  TPiston = class(TSwitch)
  private
    FManual: TManual;
    FStopFamily: TStopFamily;
  protected
    function GetName: string;
  public
    constructor Create(AOwner: TOrgan; AManual: TManual; AStopFamily: TStopFamily);

    property Manual: TManual read FManual;
    property StopFamily: TStopFamily read FStopFamily;

    property Name: string read GetName;
  end;

  TRank = class(TOrganObject)
  private
    FStop: TStop;
    FPath: string;
    FFirstPipe: Integer;
    FNumberOfPipes: Integer;
    FReleases: TStringList;
    FPercussive: Boolean;
    FChannelAssignment: TChannelAssignment;
    FHarmonicNumber: Integer;
  protected
    function GetNumberOfReleases: Integer;
    function GetReleasePath(const Index: Integer): string;
    function GetReleaseValue(const Index: Integer): Integer;
    function GetReleaseEnabled(const Index: Integer): Boolean;
    procedure SetReleaseEnabled(const Index: Integer; const Value: Boolean);

    function GetPipeFilename(const Index: Integer): string;
    function GetReleaseFilename(const Index, Release: Integer): string;
  public
    constructor Create(AOwner: TOrgan); overload;
    constructor Create(AOwner: TOrgan; APath: string; AFirstPipe, ANumberOfPipes: Integer; AReleasePaths: array of string; AReleaseValues: array of Integer); overload;

    destructor Destroy; override;

    property Stop: TStop read FStop;
    property Path: string read FPath;
    property FirstPipe: Integer read FFirstPipe;
    property NumberOfPipes: Integer read FNumberOfPipes;
    property Percussive: Boolean read FPercussive write FPercussive;
    property HarmonicNumber: Integer read FHarmonicNumber write FHarmonicNumber;
    property ReleasePath[const Index: Integer]: string read GetReleasePath;
    property ReleaseValue[const Index: Integer]: Integer read GetReleaseValue;
    property ReleaseEnabled[const Index: Integer]: Boolean read GetReleaseEnabled write SetReleaseEnabled;
    property NumberOfReleases: Integer read GetNumberOfReleases;
    property ChannelAssignment: TChannelAssignment read FChannelAssignment write FChannelAssignment;

    property PipeFilename[const Index: Integer]: string read GetPipeFilename;
    property ReleaseFilename[const Index, Release: Integer]: string read GetReleaseFilename;
  end;

  TStop = class(TSwitch)
  private
    FName: string;
    FRanks: TList;
    FManual: TManual;
    FStopFamily: TStopFamily;
    FMinFirstPipe, FMaxLastPipe: Integer;
  protected
    function GetNumberOfRanks: Integer;
    function GetRank(const Index: Integer): TRank;
  public
    constructor Create(AOwner: TOrgan); overload;
    constructor Create(AOwner: TOrgan; AName: string); overload;
    destructor Destroy; override;

    procedure InsertRank(ARank: TRank; AIndex: Integer);
    procedure RemoveRank(ARank: TRank);
    function IndexOfRank(ARank: TRank): Integer;

    property Name: string read FName write FName;
    property Manual: TManual read FManual;
    property StopFamily: TStopFamily read FStopFamily write FStopFamily;

    property NumberOfRanks: Integer read GetNumberOfRanks;
    property Rank[const Index: Integer]: TRank read GetRank;
  end;

  TLabelPosition = (lpTopLeft, lpBottomLeft, lpTopRight, lpBottomRight);

  TLabels = class(TLabelStyle)
  private
    FLabels: array[lpTopLeft .. lpBottomRight] of TStringList;
  protected
    procedure Clear; override;

    procedure SaveToFile(AFile: TCustomIniFile; ASection: string; AName: string); override;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string; AName: string); override;

    function GetLabels(const Position: TLabelPosition): TStrings;
  public
    constructor Create(AOwner: TOrgan);
    destructor Destroy; override;

    property Labels[const Position: TLabelPosition]: TStrings read GetLabels;

    property TopLeftLabels: TStrings index lpTopLeft read GetLabels;
    property BottomLeftLabels: TStrings index lpBottomLeft read GetLabels;
    property TopRightLabels: TStrings index lpTopRight read GetLabels;
    property BottomRightLabels: TStrings index lpBottomRight read GetLabels;
  end;

  TLayout = class(TOrganObject)
    FLeftMatrix: TObjectMatrix;
    FRightMatrix: TObjectMatrix;
    FCenterMatrix: TObjectMatrix;
    FSideMatrixSize: TSize;
    FPairDrawstopCols: Boolean;
    FDrawstopLayout: Integer;
    FExtraDrawstopRowsAboveExtraButtonRow: Boolean;

    FPistonMatrix: TObjectMatrix;
    FPistonMatrixWidth: Integer;
    FBottomPistonMatrixHeight: Integer;
    FTopPistonMatrixHeight: Integer;
    FPistonLayout: Integer;
    FButtonsAboveManuals: Boolean;

    FLabels: TLabels;

    FBackgroundImages: array[0..4] of Integer;
    FTrimAboveManuals: Boolean;
    FTrimBelowManuals: Boolean;
    FTrimAboveExtraRows: Boolean;

    FDefaultButtonSize: Boolean;
    FDrawstopSize: TSize;
    FPistonSize: TSize;
    FPanelSize: TSize;

    FAutoSize: TSize;
  protected
    procedure SetSideMatrixWidth(const Value: Integer);
    procedure SetSideMatrixHeight(const Value: Integer);
    procedure SetPairDrawstopCols(const Value: Boolean);

    procedure SetPistonMatrixWidth(const Value: Integer);
    procedure SetBottomPistonMatrixHeight(const Value: Integer);
    procedure SetTopPistonMatrixHeight(const Value: Integer);

    function GetBackgroundImage(const Index: Integer): Integer;
    procedure SetBackgroundImage(const Index, Value: Integer);

    function GetDrawstopWidth: Integer;
    function GetDrawstopHeight: Integer;
    function GetPistonWidth: Integer;
    function GetPistonHeight: Integer;

    procedure SaveToFile(AFile: TCustomIniFile; ASection: string); overload;
    procedure LoadFromFile(AFile: TCustomIniFile; ASection: string); overload;

    procedure Clear;

    procedure Update;

    procedure Resize;
  public
    constructor Create(AOwner: TOrgan);
    destructor Destroy; override;

    function IsObjectOnPanel(AObject: TObject): Boolean;

    property SideMatrixWidth: Integer read FSideMatrixSize.cx write SetSideMatrixWidth;
    property SideMatrixHeight: Integer read FSideMatrixSize.cy write SetSideMatrixHeight;
    property PairDrawstopCols: Boolean read FPairDrawstopCols write SetPairDrawstopCols;
    property LeftMatrix: TObjectMatrix read FLeftMatrix;
    property RightMatrix: TObjectMatrix read FRightMatrix;
    property CenterMatrix: TObjectMatrix read FCenterMatrix;
    property DrawstopLayout: Integer read FDrawstopLayout write FDrawstopLayout;
    property ExtraDrawstopRowsAboveExtraButtonRow: Boolean read FExtraDrawstopRowsAboveExtraButtonRow write FExtraDrawstopRowsAboveExtraButtonRow;

    property PistonMatrixWidth: Integer read FPistonMatrixWidth write SetPistonMatrixWidth;
    property TopPistonMatrixHeight: Integer read FTopPistonMatrixHeight write SetTopPistonMatrixHeight;
    property BottomPistonMatrixHeight: Integer read FBottomPistonMatrixHeight write SetBottomPistonMatrixHeight;
    property PistonMatrix: TObjectMatrix read FPistonMatrix;
    property PistonLayout: Integer read FPistonLayout write FPistonLayout;
    property ButtonsAboveManuals: Boolean read FButtonsAboveManuals write FButtonsAboveManuals;

    property Labels: TLabels read FLabels;

    property BackgroundImage[const Index: Integer]: Integer read GetBackgroundImage write SetBackgroundImage;
    property DrawstopBackgroundImage: Integer index 0 read GetBackgroundImage write SetBackgroundImage;
    property ConsoleBackgroundImage: Integer index 1 read GetBackgroundImage write SetBackgroundImage;
    property KeyHorizontalBackgroundImage: Integer index 2 read GetBackgroundImage write SetBackgroundImage;
    property KeyVerticalBackgroundImage: Integer index 3 read GetBackgroundImage write SetBackgroundImage;
    property DrawstopInsetBackgroundImage: Integer index 4 read GetBackgroundImage write SetBackgroundImage;
    property TrimAboveManuals: Boolean read FTrimAboveManuals write FTrimAboveManuals;
    property TrimBelowManuals: Boolean read FTrimBelowManuals write FTrimBelowManuals;
    property TrimAboveExtraRows: Boolean read FTrimAboveExtraRows write FTrimAboveExtraRows;

    property DefaultButtonSize: Boolean read FDefaultButtonSize write FDefaultButtonSize;
    property DrawstopWidth: Integer read GetDrawstopWidth write FDrawstopSize.cx;
    property DrawstopHeight: Integer read GetDrawstopHeight write FDrawstopSize.cy;
    property PistonWidth: Integer read GetPistonWidth write FPistonSize.cx;
    property PistonHeight: Integer read GetPistonHeight write FPistonSize.cy;
    property PanelWidth: Integer read FPanelSize.cx write FPanelSize.cx;
    property PanelHeight: Integer read FPanelSize.cy write FPanelSize.cy;
  end;

  TObjectMatrix = class
  private
    FData: TList;
    FWidth, FHeight: Integer;
  protected
    function GetValue(const X, Y: Integer): TObject;
    procedure SetValue(const X, Y: Integer; const Value: TObject);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Resize(AWidth, AHeight: Integer);
    procedure InsertLine(Index: Integer);
    procedure DeleteLine(Index: Integer);

    function Contains(AItem: TObject): Boolean; overload;
    function Contains(AItem: TObject; var APosition: TPoint): Boolean; overload;
    procedure Clear(DeleteObjects: Boolean = False);
    procedure Remove(AItem: TObject);

    property Value[const X, Y: Integer]: TObject read GetValue write SetValue; default;

    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
  end;

const
  GDefaultDrawstopWidth = 78;
  GDefaultDrawstopHeight = 69;
  GDefaultPistonWidth = 44;
  GDefaultPistonHeight = 40;
  GDefaultEnclosureWidth = 52;
  GDefaultEnclosureHeight = 63;
  GDefaultPedalKeyWidth = 7;
  GDefaultPedalHeight = 40;
  GDefaultManualKeyWidth = 12;
  GDefaultManualHeight = 32;

  GColors: array[0..15] of TColor = (
    $000000,
    $FF0000,
    $800000,
    $00FF00,
    $008000,
    $FFFF00,
    $808000,
    $0000FF,
    $000080,
    $FF00FF,
    $800080,
    $00FFFF,
    $008080,
    $A0A0A0,
    $505050,
    $FFFFFF
  );

  GColorNames: array[0..15] of string = (
    'BLACK',
    'BLUE',
    'DARK BLUE',
    'GREEN',
    'DARK GREEN',
    'CYAN',
    'DARK CYAN',
    'RED',
    'DARK RED',
    'MAGENTA',
    'DARK MAGENTA',
    'YELLOW',
    'DARK YELLOW',
    'LIGHT GREY',
    'DARK GREY',
    'WHITE'
  );

  GKeyNames: array[0..11] of string = (
    'A',
    'A#',
    'B',
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#'
  );

  GChannelNames: array[caNone .. caRearRight] of string = (
    'none', 'front', 'rear', 'front left', 'front right', 'rear left', 'rear right'
  );

  GRomanNumerals: array[0..16] of string = (
    'P', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI'
  );

  GDefaultPanelSizes: array[1 .. 4] of TSize = (
    (cx: 800; cy: 500),
    (cx: 1007; cy: 663),
    (cx: 1263; cy: 855),
    (cx: 1583; cy: 1095)
  );

  GSizeNames: array[1 .. 4] of string = (
    'SMALL',
    'MEDIUM',
    'MEDIUM LARGE',
    'LARGE'
  );

  GHarmonicNumbers: array[0 .. 16] of Double = (
    32,
    16,
    10 + 2 / 3,
    8,
    6 + 2 / 5,
    5 + 1 / 3,
    4,
    3 + 1 / 5,
    2 + 2 / 3,
    2,
    1 + 1 / 3,
    1 + 3 / 5,
    1,
    4 / 5,
    2 / 3,
    1 / 2,
    2 / 5
  );

implementation

var
  GDefaultFontName: string = 'Times New Roman';

  GLabelPositionNames: array[lpTopLeft .. lpBottomRight] of string = (
    'TopLeft', 'BottomLeft', 'TopRight', 'BottomRight'
  );

type
  TODFFile = class(TMemIniFile)
  public
    procedure WriteBool(const Section, Ident: string; Value: Boolean); override;
    procedure WritePath(const Section, Ident: string; Value: string; Absolute: Boolean = False);
  end;

{ TOrgan }

function TOrgan.AddStop(AName: string; AManual: TManual): TStop;
begin
  Result := TStop.Create(Self, AName);
  FStops.Add(Result);
  Result.FManual := AManual;
  Result.StopFamily := FStopFamilies[0] as TStopFamily;
  AManual.FStops.Add(Result);
end;

procedure TOrgan.Clear;
var
  a: Integer;
begin
  FFilename := '';
  FModified := False;

  FManuals.Clear;
  FreeAndNil(FPedalboard);
  SetNumberOfManuals(2);
  SetHasPedals(True);

  FStopFamilies.Clear;
  SetNumberOfStopFamilies(2);

  FCouplers.Clear;
  FTremulants.Clear;
  FEnclosures.Clear;

  FRanks.Clear;
  FStops.Clear;

  FLayout.Clear;

  for a := 0 to 6 do
    FInfos[a] := '';
  OrganComments := Format(S_GeneratedUsingOrganBuilderVersion, [S_Version]);

  FExportFilename := '';
end;

constructor TOrgan.Create;
begin
  inherited;
  FSection := TCriticalSection.Create;
  FWarnings := TStringList.Create;

  FManuals := TObjectList.Create(True);

  FCouplers := TCouplers.Create(Self);
  FTremulants := TTremulants.Create(Self);
  FEnclosures := TEnclosures.Create(Self);

  FStopFamilies := TObjectList.Create(True);

  FPistons := TObjectList.Create(True);
  FRanks := TObjectList.Create(True);
  FStops := TObjectList.Create(True);

  FLayout := TLayout.Create(Self);

  Clear;
end;

destructor TOrgan.Destroy;
begin
  FreeAndNil(FLayout);

  FreeAndNil(FStops);
  FreeAndNil(FRanks);
  FreeAndNil(FPistons);

  FreeAndNil(FStopFamilies);

  FreeAndNil(FTremulants);
  FreeAndNil(FEnclosures);
  FreeAndNil(FCouplers);

  FreeAndNil(FPedalboard);
  FreeAndNil(FManuals);

  FreeAndNil(FWarnings);
  FreeAndNil(FSection);
  inherited;
end;

function TOrgan.GetHasPedals: Boolean;
begin
  Result := Assigned(FPedalboard);
end;

function TOrgan.GetManual(const Index: Integer): TManual;
begin
  if Index = 0 then
    Result := FPedalboard
  else
    Result := FManuals[Index - 1] as TManual;
end;

function TOrgan.GetNumberOfManuals: Integer;
begin
  Result := FManuals.Count;
end;

function TOrgan.GetNumberOfRanks: Integer;
begin
  Result := FRanks.Count;
end;

function TOrgan.GetNumberOfStopFamilies: Integer;
begin
  Result := FStopFamilies.Count;
end;

function TOrgan.GetNumberOfStops: Integer;
begin
  Result := FStops.Count;
end;

function TOrgan.GetRank(const Index: Integer): TRank;
begin
  Result := FRanks[Index] as TRank;
end;

function TOrgan.GetStop(const Index: Integer): TStop;
begin
  Result := FStops[Index] as TStop;
end;

function TOrgan.GetStopFamily(const Index: Integer): TStopFamily;
begin
  Result := FStopFamilies[Index] as TStopFamily;
end;

function TOrgan.IndexOfStopFamily(AStopFamily: TStopFamily): Integer;
begin
  Result := FStopFamilies.IndexOf(AStopFamily);
end;

procedure TOrgan.LoadFromFile(AFile: TProjectFile);
var
  a, b, c, d: Integer;
  e: TCouplerDelta;
  s: string;
  Manual: TManual;
  StopFamily: TStopFamily;
  Stop: TStop;
  Rank: TRank;
begin
  Clear;
  FFontWarning := False;
  for a := Low(FInfos) to High(FInfos) do
    if a <> 6 then
      FInfos[a] := AFile.ReadString('Organ', 'Info[' + IntToStr(a) + ']', FInfos[a]);
  FInfos[6] := AFile.ReadPath('Organ', 'Info[6]', FInfos[6]);
  SetNumberOfStopFamilies(AFile.ReadInteger('Organ', 'NumberOfStopFamilies', 1));
  for a := 0 to NumberOfStopFamilies - 1 do begin
    StopFamily := GetStopFamily(a);
    s := 'StopFamily' + IntToStr(a);
    StopFamily.LoadFromFile(AFile, s, '');
  end;
  b := AFile.ReadInteger('Organ', 'NumberOfRanks', 0);
  for a := 0 to b - 1 do begin
    s := 'Rank' + IntToStr(a);
    Rank := TRank.Create(Self);
    FRanks.Add(Rank);
    Rank.FPath := AFile.ReadPath(s, 'Path', '');
    Rank.FFirstPipe := AFile.ReadInteger(s, 'FirstPipe', 0);
    Rank.FNumberOfPipes := AFile.ReadInteger(s, 'NumberOfPipes', 0);
    d := AFile.ReadInteger(s, 'NumberOfReleases', 0);
    for c := 0 to d - 1 do
      Rank.FReleases.AddObject(AFile.ReadPath(s, 'Release' + IntToStr(c) + 'Path', ''), TObject(AFile.ReadInteger(s, 'Release' + IntToStr(c) + 'Value', 0)));
    Rank.FPercussive := AFile.ReadBool(s, 'Percussive', False);
    Rank.FHarmonicNumber := AFile.ReadInteger(s, 'HarmonicNumber', Rank.FHarmonicNumber);
    Rank.FChannelAssignment := TChannelAssignment(AFile.ReadInteger(s, 'ChannelAssignment', 0));  
  end;
  b := AFile.ReadInteger('Organ', 'NumberOfStops', 0);
  for a := 0 to b - 1 do begin
    s := 'Stop' + IntToStr(a);
    Stop := TStop.Create(Self);
    FStops.Add(Stop);
    Stop.FName := AFile.ReadString(s, 'Name', s);
    d :=AFile.ReadInteger(s, 'NumberOfRanks', 0);
    for c := 0 to d - 1 do begin
      Rank := GetRank(AFile.ReadInteger(s, 'Rank' + IntToStr(c), - 1));
      Stop.FRanks.Add(Rank);
      Rank.FStop := Stop;
    end;
    Stop.FStopFamily := (FStopFamilies[AFile.ReadInteger(s, 'StopFamily', 0)]) as TStopFamily;
  end;
  SetNumberOfManuals(AFile.ReadInteger('Organ', 'NumberOfManuals', NumberOfManuals));
  SetHasPedals(AFile.ReadBool('Organ', 'HasPedals', False));
  if HasPedals then
    c := 0
  else
    c := 1;
  for a := c to NumberOfManuals do begin
    Manual := GetManual(a);
    s := 'Manual' + IntToStr(a);
    Manual.FName := AFile.ReadString(s, 'Name', Manual.FName);
    Manual.FAbbreviatedName := AFile.ReadString(s, 'AbbreviatedName', Manual.FAbbreviatedName);
    Manual.FComment := AFile.ReadString(s, 'Comment', Manual.FComment);
    Manual.FNumberOfKeys := AFile.ReadInteger(s, 'NumberOfKeys', Manual.FNumberOfKeys);
    Manual.FFirstKey := AFile.ReadInteger(s, 'FirstKey', Manual.FFirstKey);
    d := AFile.ReadInteger(s, 'NumberOfStops', 0);
    for b := 0 to d - 1 do begin
      Stop := GetStop(AFile.ReadInteger(s, 'Stop' + IntToStr(b), - 1));
      Manual.FStops.Add(Stop);
      Stop.FManual := Manual;
    end;
    Manual.FInvisible := AFile.ReadBool(s, 'Invisible', Manual.FInvisible);
    Manual.FAppearance := AFile.ReadInteger(s, 'Appearance', Manual.FAppearance);
    Manual.FHasEnclosure := AFile.ReadBool(s, 'HasEnclosure', Manual.FHasEnclosure);
    Manual.FEnclosureMinimumLevel := AFile.ReadInteger(s, 'EnclosureMinimumLevel', Manual.FEnclosureMinimumLevel);
    Manual.SetHasTremulant(AFile.ReadBool(s, 'HasTremulant', Manual.FHasTremulant));
    Manual.FTremulant.FPeriod := AFile.ReadInteger(s, 'TremulantPeriod', Manual.FTremulant.FPeriod);
    Manual.FTremulant.FStartRate := AFile.ReadInteger(s, 'TremulantStartRate', Manual.FTremulant.FStartRate);
    Manual.FTremulant.FStopRate := AFile.ReadInteger(s, 'TremulantStopRate', Manual.FTremulant.FStopRate);
    Manual.FTremulant.FAmpModDepth := AFile.ReadInteger(s, 'TremulantAmpModDepth', Manual.FTremulant.FAmpModDepth);
    for b := c to NumberOfManuals do
      for e := cdMinus8 to cdPlus8 do
        FCouplers[GetManual(a), GetManual(b), e].FActive := AFile.ReadBool('Couplers', 'Coupler[' + IntToStr(a) + ',' + IntToStr(b) + ',' + IntToStr(Integer(e)) + ']', FCouplers[GetManual(a), GetManual(b), e].FActive);
  end;
  FCouplers.LoadFromFile(AFile, 'Organ', 'Couplers');
  FCouplers.Update;
  FTremulants.LoadFromFile(AFile, 'Organ', 'Tremulants');
  FEnclosures.LoadFromFile(AFile, 'Organ', 'Enclosures');
  FLayout.LoadFromFile(AFile, 'Layout0');
  if FFontWarning then begin
    MessageBox(Application.Handle, PChar(S_SomeFontsWereUnavailable), PChar(S_Warning), MB_ICONWARNING or MB_OK);
    FModified := True;
  end;
  FExportFilename := AFile.ReadString('System', 'ExportFilename', FExportFilename);
end;

procedure TOrgan.LoadFromFile(AFilename: string);
var
  f: TProjectFile;
begin
  f := TProjectFile.Create(AFilename);
  try
    LoadFromFile(f);
    FFilename := AFilename;
  finally
    f.Destroy;
  end;
end;

procedure TOrgan.RemoveRank(ARank: TRank);
begin
  if Assigned(ARank.FStop) then
    ARank.FStop.FRanks.Remove(ARank);
  FRanks.Remove(ARank);
end;

procedure TOrgan.RemoveStop(AStop: TStop);
var
  a: Integer;
begin
  for a := 0 to AStop.FRanks.Count - 1 do
    TRank(AStop.FRanks[a]).FStop := nil;
  if Assigned(AStop.FManual) then
    AStop.FManual.FStops.Remove(AStop);
  FLayout.FLeftMatrix.Remove(AStop);
  FLayout.FRightMatrix.Remove(AStop);
  FLayout.FCenterMatrix.Remove(AStop);
  FLayout.FPistonMatrix.Remove(AStop);
  FStops.Remove(AStop);
end;

procedure TOrgan.SaveToFile(AFile: TProjectFile);
var
  a, b, c: Integer;
  d: TCouplerDelta;
  s: string;
  Manual: TManual;
  StopFamily: TStopFamily;
  Stop: TStop;
  Rank: TRank;
begin
  for a := Low(FInfos) to High(FInfos) do
    if a <> 6 then
      AFile.WriteString('Organ', 'Info[' + IntToStr(a) + ']', FInfos[a]);
  AFile.WritePath('Organ', 'Info[6]', FInfos[6]);
  AFile.WriteInteger('Organ', 'NumberOfStopFamilies', NumberOfStopFamilies);
  for a := 0 to NumberOfStopFamilies - 1 do begin
    StopFamily := GetStopFamily(a);
    s := 'StopFamily' + IntToStr(a);
    StopFamily.SaveToFile(AFile, s, '');
  end;
  AFile.WriteInteger('Organ', 'NumberOfRanks', NumberOfRanks);
  for a := 0 to NumberOfRanks - 1 do begin
    s := 'Rank' + IntToStr(a);
    Rank := GetRank(a);
    AFile.WritePath(s, 'Path', Rank.FPath);
    AFile.WriteInteger(s, 'FirstPipe', Rank.FFirstPipe);
    AFile.WriteInteger(s, 'NumberOfPipes', Rank.FNumberOfPipes);
    AFile.WriteInteger(s, 'NumberOfReleases', Rank.NumberOfReleases);
    for b := 0 to Rank.NumberOfReleases - 1 do begin
      AFile.WritePath(s, 'Release' + IntToStr(b) + 'Path', Rank.FReleases[b]);
      AFile.WriteInteger(s, 'Release' + IntToStr(b) + 'Value', Integer(Rank.FReleases.Objects[b]));
    end;
    AFile.WriteBool(s, 'Percussive', Rank.FPercussive);
    AFile.WriteInteger(s, 'HarmonicNumber', Rank.FHarmonicNumber);
    AFile.WriteInteger(s, 'ChannelAssignment', Integer(Rank.FChannelAssignment));
  end;
  AFile.WriteInteger('Organ', 'NumberOfStops', NumberOfStops);
  for a := 0 to NumberOfStops - 1 do begin
    s := 'Stop' + IntToStr(a);
    Stop := GetStop(a);
    AFile.WriteString(s, 'Name', Stop.FName);
    AFile.WriteInteger(s, 'NumberOfRanks', Stop.NumberOfRanks);
    for b := 0 to Stop.NumberOfRanks - 1 do
      AFile.WriteInteger(s, 'Rank' + IntToStr(b), FRanks.IndexOf(Stop.GetRank(b)));
    AFile.WriteInteger(s, 'StopFamily', FStopFamilies.IndexOf(Stop.FStopFamily));
  end;
  AFile.WriteInteger('Organ', 'NumberOfManuals', GetNumberOfManuals);
  AFile.WriteBool('Organ', 'HasPedals', HasPedals);
  if HasPedals then
    c := 0
  else
    c := 1;
  for a := c to NumberOfManuals do begin
    Manual := GetManual(a);
    s := 'Manual' + IntToStr(a);
    AFile.WriteString(s, 'Name', Manual.FName);
    AFile.WriteString(s, 'AbbreviatedName', Manual.FAbbreviatedName);
    AFile.WriteInteger(s, 'NumberOfKeys', Manual.FNumberOfKeys);
    AFile.WriteInteger(s, 'FirstKey', Manual.FFirstKey);
    AFile.WriteInteger(s, 'NumberOfStops', Manual.NumberOfStops);
    for b := 0 to Manual.NumberOfStops - 1 do
      AFile.WriteInteger(s, 'Stop' + IntToStr(b), FStops.IndexOf(Manual.GetStop(b)));
    for b := c to NumberOfManuals do
      for d := cdMinus8 to cdPlus8 do
        AFile.WriteBool('Couplers', 'Coupler[' + IntToStr(a) + ',' + IntToStr(b) + ',' + IntToStr(Integer(d)) + ']', FCouplers[GetManual(a), GetManual(b), d].FActive);
    AFile.WriteInteger(s, 'Appearance', Manual.FAppearance);
    AFile.WriteBool(s, 'Invisible', Manual.FInvisible);
    AFile.WriteBool(s, 'HasEnclosure', Manual.FHasEnclosure);
    AFile.WriteInteger(s, 'EnclosureMinimumLevel', Manual.FEnclosureMinimumLevel);
    AFile.WriteBool(s, 'HasTremulant', Manual.FHasTremulant);
    AFile.WriteInteger(s, 'TremulantPeriod', Manual.FTremulant.FPeriod);
    AFile.WriteInteger(s, 'TremulantStartRate', Manual.FTremulant.FStartRate);
    AFile.WriteInteger(s, 'TremulantStopRate', Manual.FTremulant.FStopRate);
    AFile.WriteInteger(s, 'TremulantAmpModDepth', Manual.FTremulant.FAmpModDepth);
  end;
  FCouplers.SaveToFile(AFile, 'Organ', 'Couplers');
  FTremulants.SaveToFile(AFile, 'Organ', 'Tremulants');
  FEnclosures.SaveToFile(AFile, 'Organ', 'Enclosures');
  FLayout.SaveToFile(AFile, 'Layout0');
  AFile.WriteString('System', 'ExportFilename', FExportFilename);
  AFile.WriteString('System', 'Version', S_Version);
end;

procedure TOrgan.SaveToFile(AFilename: string; StoreRelativePaths: Boolean);
var
  f: TProjectFile;
begin
  f := TProjectFile.Create(AFilename, StoreRelativePaths);
  try
    SaveToFile(f);
    f.UpdateFile;
    FFilename := AFilename;
    FModified := False;
  finally
    f.Destroy;
  end;
end;

procedure TOrgan.ScanFileSystem(ABasePath: string; AInterrupt: PBoolean);

  function IsReleaseName(Name: string; var Value: Integer): Boolean;
  var
    p: PChar;
  begin
    Result := (UpperCase(Copy(Name, 1, 3)) = 'REL') and (Length(Name) > 3);
    if Result then begin
      p := PChar(Name) + 3;
      while p^ <> #0 do begin
        Result := Result and (p^ in ['0' .. '9']);
        Inc(p);
      end;
      if Result then
        Value := StrToInt(Copy(Name, 4, Length(Name) - 3));
    end;
  end;

  function IsPipeName(Name: string; var Key: Integer): Boolean;
  type
    TState = (sNumber, sKey, sPostfix, sExtension);
  var
    p, q: PChar;
    s: TState;
    t: array[sNumber .. sExtension] of PChar;
  begin
    p := PChar(Name);
    Result := False;
    while p^ <> #0 do begin
      q := p;
      t[sNumber] := q;
      s := sNumber;
      while q^ <> #0 do begin
        case s of
          sNumber: begin
            case q^ of
              '0'..'9': Inc(q);
              '-': begin
                Inc(q);
                t[sKey] := q;
                s := sKey;
              end;
            else
              Break;
            end;
          end;
          sKey: begin
            case q^ of
              'a' .. 'g', 'A' .. 'G': Inc(q);
            else
              Break;
            end;
            case q^ of
              '#': Inc(q);
            end;
            t[sPostfix] := q;
            s := sPostfix;
          end;
          sPostfix: begin
            case q^ of
              '.': begin
                t[sExtension] := q;
                s := sExtension;
              end;
            else
              Break;
//              Inc(q);
            end;
          end;
          sExtension: begin
            Result := UpperCase(string(q)) = '.WAV';
            if Result then
              Key := StrToInt(Copy(t[sNumber], 1, t[sKey] - t[sNumber] - 1));
            Exit;
          end;
        end;
      end;
      Inc(p);
    end;
  end;

{$WARNINGS OFF}
  procedure ParseFolder(FolderPath: string);
  var
    Files, Folders: TStringList;
    a, b, FirstPipe, NumberOfPipes: Integer;
    ReleaseNames: array of string;
    ReleaseValues: array of Integer;
    Rank: TRank;
    r: TSearchRec;
    s: string;
  begin
    FSection.Enter;
    try
      FScanPath := FolderPath;
    finally
      FSection.Leave;
    end;
    Files := TStringList.Create;
    Folders := TStringList.Create;
    try
      Files.Sorted := True;
      Files.CaseSensitive := False;
      Files.Duplicates := dupIgnore;
      Folders.Sorted := True;
      Folders.CaseSensitive := False;
      Folders.Duplicates := dupIgnore;
      if FolderPath = '' then
        s := ABasePath + '\*'
      else
        s := ABasePath + '\' + FolderPath + '\*';
      if FindFirst(s, faAnyFile or faDirectory, r) = 0 then
        try
          repeat
            if Assigned(AInterrupt) and AInterrupt^ then
              Break;
            if (r.Attr and faDirectory = faDirectory) and (r.Name <> '.') and (r.Name <> '..') then
              Folders.Add(r.Name);
            if (r.Attr and faDirectory = 0) and IsPipeName(r.Name, a) then
              Files.AddObject(r.Name, TObject(a));
          until FindNext(r) <> 0;
        finally
          FindClose(r);
        end;
      if not Assigned(AInterrupt) or not AInterrupt^ then begin
        NumberOfPipes := 0;
        if Files.Count > 0 then begin
          FirstPipe := Integer(Files.Objects[0]);
          NumberOfPipes := 1;
          while (NumberOfPipes < Files.Count) and (Integer(Files.Objects[NumberOfPipes]) = FirstPipe + NumberOfPipes) do
            Inc(NumberOfPipes);
        end;
        if NumberOfPipes > 1 then begin
          if FolderPath = '' then
            s := ABasePath
          else
            s := ABasePath + '\' + FolderPath;
          for a := 0 to Folders.Count - 1 do
            if IsReleaseName(Folders[a], b) then begin
              SetLength(ReleaseNames, High(ReleaseNames) + 2);
              SetLength(ReleaseValues, High(ReleaseValues) + 2);
              ReleaseNames[High(ReleaseNames)] := Folders[a];
              ReleaseValues[High(ReleaseValues)] := b;
            end;
          b := -1;
          for a := 0 to FRanks.Count - 1 do
            if UpperCase(TRank(FRanks[a]).FPath) = UpperCase(s) then
              b := a;
          if b = -1 then begin
            Rank := TRank.Create(Self, s, FirstPipe, NumberOfPipes, ReleaseNames, ReleaseValues);
            FRanks.Add(Rank);
            Inc(FFoundRanks);
          end;
        end else begin
          if FolderPath = '' then
            s := ''
          else
            s := FolderPath + '\';
          for a := 0 to Folders.Count - 1 do
            ParseFolder(s + Folders[a]);
        end;
      end;
    finally
      Files.Destroy;
      Folders.Destroy;
    end;
  end;
{$WARNINGS ON}

begin
  while (ABasePath <> '') and (ABasePath[Length(ABasePath)] = '\') do
    ABasePath := Copy(ABasePath, 1, Length(ABasePath) - 1);
  FFoundRanks := 0;
  ParseFolder('');
end;

procedure TOrgan.SetHasPedals(const Value: Boolean);
begin
  if Value xor Assigned(FPedalboard) then begin
    if Value then
      FPedalboard := TManual.Create(Self, 0)
    else
      FreeAndNil(FPedalboard);
  end;
  FCouplers.Update;
  UpdatePistons;
  FLayout.Update;
end;

procedure TOrgan.SetNumberOfManuals(const Value: Integer);
begin
  while FManuals.Count > Value do begin
    with FManuals[FManuals.Count - 1] as TManual do begin
      while FStops.Count > 0 do
        RemoveStop(TStop(FStops[FStops.Count - 1]));
      FLayout.FLeftMatrix.Remove(FTremulant);
      FLayout.FRightMatrix.Remove(FTremulant);
      FLayout.FCenterMatrix.Remove(FTremulant);
      FLayout.FPistonMatrix.Remove(FTremulant);
    end;
    FManuals.Delete(FManuals.Count - 1);
  end;
  while FManuals.Count < Value do
    FManuals.Add(TManual.Create(Self, FManuals.Count + 1));
  FCouplers.Update;
  UpdatePistons;
  FLayout.Update;
end;

procedure TOrgan.SetNumberOfStopFamilies(const Value: Integer);
var
  a: Integer;
begin
  while FStopFamilies.Count > Value do begin
    for a := 0 to FStops.Count - 1 do
      with FStops[a] as TStop do
        if FStopFamily = FStopFamilies[FStopFamilies.Count - 1] then
          FStopFamily := FStopFamilies[0] as TStopFamily;
    FStopFamilies.Delete(FStopFamilies.Count - 1);
  end;
  while FStopFamilies.Count < Value do
    FStopFamilies.Add(TStopFamily.Create(Self, FStopFamilies.Count));
end;

function TOrgan.IndexOfManual(AManual: TManual): Integer;
begin
  Result := FManuals.IndexOf(AManual);
  if Result = -1 then begin
    if AManual = FPedalBoard then
      Result := 0;
  end else
    Inc(Result);
end;

function TOrgan.GetPiston(AManual: TManual; AStopFamily: TStopFamily): TPiston;
var
  a: Integer;
begin
  Result := nil;
  for a := 0 to FPistons.Count - 1 do
    with FPistons[a] as TPiston do
      if (FManual = AManual) and (FStopFamily = AStopFamily) then
        Result := FPistons[a] as TPiston;
end;

procedure TOrgan.UpdatePistons;
var
  a, b, c, d: Integer;
  t: Boolean;
begin
  for a := FPistons.Count - 1 downto 0 do begin
    with FPistons[a] as TPiston do begin
      b := FManuals.IndexOf(FManual);
      c := FStopFamilies.IndexOf(FStopFamily);
      t := (b = - 1) and (FManual <> FPedalBoard) or (c = - 1);
    end;
    if t or not (FPistons[a] as TPiston).FStopFamily.FHasPiston then begin
      FLayout.FLeftMatrix.Remove(FPistons[a]);
      FLayout.FRightMatrix.Remove(FPistons[a]);
      FLayout.FCenterMatrix.Remove(FPistons[a]);
      FLayout.FPistonMatrix.Remove(FPistons[a]);
    end;
    if t then
      FPistons.Delete(a);
  end;
  if Assigned(FPedalBoard) then
    a := 0
  else
    a := 1;
  for b := a to FManuals.Count do
    for c := 0 to FStopFamilies.Count - 1 do begin
      t := False;
      for d := 0 to FPistons.Count - 1 do
        with FPistons[d] as TPiston do
          t := t or (FManual = GetManual(b)) and (FStopFamily = FStopFamilies[c]);
        if not t then
          FPistons.Add(TPiston.Create(Self, GetManual(b), FStopFamilies[c] as TStopFamily));
      end;
{  for b := 1 to FManuals.Count do
    if GetManual(b).Invisible then
      for c := 0 to FPistonMatrixWidth - 1 do
        FPistonMatrix[c, FTopPistonMatrixHeight + b] := nil;}
end;

procedure TOrgan.Export(AFilename: string; AInterrupt: PBoolean);
var
  a, b, c, d, e: Integer;
  f: TODFFile;
  p: TLabelPosition;
  s: string;
  Stops, Ranks, Switches, Couplers, Enclosures, Tremulants, Pistons: TList;
  Labels: TStringList;
begin
  if FExportFilename <> AFilename then
    MarkModified;
  FExportFilename := AFilename;
  SetExportProgress(0);
  f := TODFFile.Create(AFilename);
  Stops := TList.Create;
  Ranks := TList.Create;
  Switches := TList.Create;
  Couplers := TList.Create;
  Enclosures := TList.Create;
  Tremulants := TList.Create;
  Pistons := TList.Create;
  Labels := TStringList.Create;
  try
    f.Clear;
    FLayout.Resize;
    for a := 0 to FCouplers.FCouplers.Count - 1 do
      with FCouplers.FCouplers[a] as TCoupler do begin
        UpdateLayout;
        if FDisplayed then
          Couplers.Add(FCouplers.FCouplers[a]);
      end;
    for a := 0 to FPistons.Count - 1 do
      with FPistons[a] as TPiston do begin
        UpdateLayout;
        if FDisplayed then begin
          Pistons.Add(FPistons[a]);
          Switches.Add(FPistons[a]);
        end;
      end;
    for a := 0 to FStops.Count - 1 do
      with FStops[a] as TStop do begin
        UpdateLayout;
        FDisplayed := FDisplayed and (not FStopFamily.FHasPiston or GetPiston(FManual, FStopFamily).FDisplayed) and (FRanks.Count > 0);
        if FDisplayed then begin
          Stops.Add(FStops[a]);
          FMinFirstPipe := TRank(FRanks[0]).FFirstPipe;
          FMaxLastPipe := FMinFirstPipe + TRank(FRanks[0]).FNumberOfPipes;
          for b := 1 to FRanks.Count - 1 do
            with TRank(FRanks[b]) do begin
              if FFirstPipe < FMinFirstPipe then
                FMinFirstPipe := FFirstPipe;
              if FFirstPipe + FNumberOfPipes - 1 > FMaxLastPipe then
                FMaxLastPipe := FFirstPipe + FNumberOfPipes - 1;
            end;
          if FStopFamily.FHasPiston then
            Switches.Add(FStops[a]);
          if FRanks.Count > 1 then
            for b := 0 to FRanks.Count - 1 do
              Ranks.Add(FRanks[b])
        end;
      end;
    if HasPedals then
      e := 0
    else
      e := 1;
    for a := e to FManuals.Count do
      with GetManual(a) do begin
        if FHasEnclosure then
          Enclosures.Add(GetManual(a));
        if FHasTremulant then begin
          FTremulant.UpdateLayout;
          if FTremulant.FDisplayed then
            Tremulants.Add(FTremulant);
        end;
      end;
    for p := lpTopLeft to lpBottomRight do
      for a := 0 to FLayout.FLabels.FLabels[p].Count - 1 do
        if FLayout.FLabels.FLabels[p][a] <> '' then begin
          b := (a div 2) or ((a mod 2) * $100);
          if p in [lpTopRight, lpBottomRight] then
            b := b + FLayout.FSideMatrixSize.cx;
          if p in [lpBottomLeft, lpBottomRight] then
            b := b or $1000;
          Labels.AddObject(FLayout.FLabels.FLabels[p][a], TObject(b));
        end;
    f.WriteString('Organ', 'ChurchName', ChurchName);
    f.WriteString('Organ', 'ChurchAddress', ChurchAddress);
    f.WriteString('Organ', 'OrganBuilder', OrganBuilder);
    f.WriteString('Organ', 'OrganBuildDate', OrganBuildDate);
    f.WriteString('Organ', 'OrganComments', OrganComments);
    f.WriteString('Organ', 'RecordingDetails', RecordingDetails);
    f.WriteString('Organ', 'InfoFilename', InfoFilename);
    f.WriteInteger('Organ', 'NumberOfManuals', NumberOfManuals);
    f.WriteBool('Organ', 'HasPedals', HasPedals);
    f.WriteInteger('Organ', 'NumberOfEnclosures', Enclosures.Count);
    f.WriteInteger('Organ', 'NumberOfTremulants', Tremulants.Count);
    f.WriteInteger('Organ', 'NumberOfWindchestGroups', NumberOfManuals + 1 - e);
    f.WriteInteger('Organ', 'NumberOfReversiblePistons', Pistons.Count);
    f.WriteInteger('Organ', 'NumberOfGenerals', 0);
    f.WriteInteger('Organ', 'NumberOfDivisionalCouplers', 0);
    f.WriteInteger('Organ', 'NumberOfPanels', 0);
    f.WriteInteger('Organ', 'NumberOfSwitches', Switches.Count);
    f.WriteInteger('Organ', 'NumberOfRanks', Ranks.Count);
    f.WriteBool('Organ', 'DivisionalsStoreIntermanualCouplers', True);
    f.WriteBool('Organ', 'DivisionalsStoreIntramanualCouplers', True);
    f.WriteBool('Organ', 'DivisionalsStoreTremulants', True);
    f.WriteBool('Organ', 'GeneralsStoreDivisionalCouplers', True);
    f.WriteBool('Organ', 'CombinationsStoreNonDisplayedDrawstops', True);
    f.WriteInteger('Organ', 'NumberOfImages', 0);
    f.WriteInteger('Organ', 'NumberOfSetterElements', 0);
    f.WriteInteger('Organ', 'NumberOfLabels', Labels.Count);
    f.WriteFloat('Organ', 'AmplitudeLevel', 100);
    f.WriteFloat('Organ', 'Gain', 0);
    f.WriteFloat('Organ', 'PitchTuning', 0);
    f.WriteInteger('Organ', 'TrackerDelay', 0);

    case FLayout.FPanelSize.cx of
      1 .. 4: f.WriteString('Organ', 'DispScreenSizeHoriz', GSizeNames[FLayout.FPanelSize.cx]);
    else
      f.WriteInteger('Organ', 'DispScreenSizeHoriz', FLayout.FAutoSize.cx);
    end;
    case FLayout.FPanelSize.cy of
      1 .. 4: f.WriteString('Organ', 'DispScreenSizeVert', GSizeNames[FLayout.FPanelSize.cy]);
    else
      f.WriteInteger('Organ', 'DispScreenSizeVert', FLayout.FAutoSize.cy);
    end;
    f.WriteInteger('Organ', 'DispDrawstopBackgroundImageNum', FLayout.DrawstopBackgroundImage + 1);
    f.WriteInteger('Organ', 'DispConsoleBackgroundImageNum', FLayout.ConsoleBackgroundImage + 1);
    f.WriteInteger('Organ', 'DispKeyHorizBackgroundImageNum', FLayout.KeyHorizontalBackgroundImage + 1);
    f.WriteInteger('Organ', 'DispKeyVertBackgroundImageNum', FLayout.KeyVerticalBackgroundImage + 1);
    f.WriteInteger('Organ', 'DispDrawstopInsetBackgroundImageNum', FLayout.DrawstopInsetBackgroundImage + 1);
    f.WriteString('Organ', 'DispControlLabelFont', FLayout.FLabels.FFontName);
    f.WriteString('Organ', 'DispShortcutKeyLabelFont', FLayout.FLabels.FFontName);
    f.WriteString('Organ', 'DispShortcutKeyLabelColour', FLayout.FLabels.ODFFontColor);
    f.WriteString('Organ', 'DispGroupLabelFont', FLayout.FLabels.FFontName);
    f.WriteInteger('Organ', 'DispDrawstopCols', 2 * FLayout.FSideMatrixSize.cx);
    f.WriteInteger('Organ', 'DispDrawstopRows', FLayout.FSideMatrixSize.cy);
    f.WriteBool('Organ', 'DispDrawstopColsOffset', FLayout.FDrawstopLayout > 0);
    f.WriteBool('Organ', 'DispDrawstopOuterColOffsetUp', FLayout.FDrawstopLayout = 1);
    f.WriteBool('Organ', 'DispPairDrawstopCols', FLayout.FPairDrawstopCols);
    f.WriteInteger('Organ', 'DispExtraDrawstopCols', FLayout.FCenterMatrix.Width);
    f.WriteInteger('Organ', 'DispExtraDrawstopRows', FLayout.FCenterMatrix.Height);
    f.WriteInteger('Organ', 'DispButtonCols', FLayout.FPistonMatrixWidth);
    f.WriteInteger('Organ', 'DispExtraButtonRows', FLayout.FTopPistonMatrixHeight);
    f.WriteBool('Organ', 'DispExtraPedalButtonRow', FLayout.FBottomPistonMatrixHeight > 1);
    f.WriteBool('Organ', 'DispExtraPedalButtonRowOffset', FLayout.FPistonLayout > 0);
    f.WriteBool('Organ', 'DispExtraPedalButtonRowOffsetRight', FLayout.FPistonLayout = 1);
    f.WriteBool('Organ', 'DispButtonsAboveManuals', FLayout.FButtonsAboveManuals);
    f.WriteBool('Organ', 'DispTrimAboveManuals', FLayout.FTrimAboveManuals);
    f.WriteBool('Organ', 'DispTrimBelowManuals', FLayout.FTrimBelowManuals);
    f.WriteBool('Organ', 'DispTrimAboveExtraRows', FLayout.FTrimAboveExtraRows);
    f.WriteBool('Organ', 'DispExtraDrawstopRowsAboveExtraButtonRows', FLayout.FExtraDrawstopRowsAboveExtraButtonRow);
    f.WriteInteger('Organ', 'DispDrawstopWidth', FLayout.GetDrawstopWidth);
    f.WriteInteger('Organ', 'DispDrawstopHeight', FLayout.GetDrawstopHeight);
    f.WriteInteger('Organ', 'DispPistonWidth', FLayout.GetPistonWidth);
    f.WriteInteger('Organ', 'DispPistonHeight', FLayout.GetPistonHeight);
    f.WriteInteger('Organ', 'DispEnclosureWidth', GDefaultEnclosureWidth);
    f.WriteInteger('Organ', 'DispEnclosureHeight', GDefaultEnclosureHeight);
    f.WriteInteger('Organ', 'DispPedalHeight', GDefaultPedalHeight);
    f.WriteInteger('Organ', 'DispPedalKeyWidth', GDefaultPedalKeyWidth);
    f.WriteInteger('Organ', 'DispManualHeight', GDefaultManualHeight);
    f.WriteInteger('Organ', 'DispManualKeyWidth', GDefaultManualKeyWidth);

    for a := e to FManuals.Count do begin
      s := Format('Manual%.3d', [a]);
      f.WriteString(s, 'Name', GetManual(a).FName);
      f.WriteInteger(s, 'NumberOfLogicalKeys', GetManual(a).FNumberOfKeys);
      f.WriteInteger(s, 'FirstAccessibleKeyLogicalKeyNumber', 1);
      f.WriteInteger(s, 'FirstAccessibleKeyMIDINoteNumber', GetManual(a).FFirstKey);
      f.WriteInteger(s, 'NumberOfAccessibleKeys', GetManual(a).FNumberOfKeys);
      f.WriteInteger(s, 'MIDIInputNumber', a + 1);
      f.WriteBool(s, 'Displayed', True);
      c := 0;
      for b := 0 to Stops.Count - 1 do
        with TStop(Stops[b]) do
          if FManual = GetManual(a) then begin
            Inc(c);
            f.WriteInteger(s, Format('Stop%.3d', [c]), b + 1);
          end;
      f.WriteInteger(s, 'NumberOfStops', c);
      c := 0;
      for b := 0 to Couplers.Count - 1 do
        with TCoupler(Couplers[b]) do
          if FSource = GetManual(a) then begin
            Inc(c);
            f.WriteInteger(s, Format('Coupler%.3d', [c]), b + 1);
          end;
      f.WriteInteger(s, 'NumberOfCouplers', c);
      f.WriteInteger(s, 'NumberOfDivisionals', 0);
      f.WriteInteger(s, 'NumberOfTremulants', 0);
      c := 0;
      for b := 0 to Switches.Count - 1 do
        with TStop(Switches[b]) do
          if FManual = GetManual(a) then begin
            Inc(c);
            f.WriteInteger(s, Format('Switch%.3d', [c]), b + 1);
          end;
      f.WriteInteger(s, 'NumberOfSwitches', c);
      f.WriteBool(s, 'Displayed', not GetManual(a).FInvisible);
      if not GetManual(a).FInvisible then begin
        if a = 0 then begin
          f.WriteBool(s, 'DispKeyColourInverted', GetManual(a).Appearance = 1);
          f.WriteBool(s, 'DispKeyColourWooden', True);
        end else begin
          f.WriteBool(s, 'DispKeyColourInverted', GetManual(a).Appearance  in [1, 3]);
          f.WriteBool(s, 'DispKeyColourWooden', GetManual(a).Appearance  in [2, 3]);
        end;
      end;
      s := Format('WindchestGroup%.3d', [a + 1 - e]);
      f.WriteString(s, 'Name', GetManual(a).FName);
      if GetManual(a).FComment <> '' then
        f.WriteString(s, 'Comment', '');
      if GetManual(a).FHasEnclosure then begin
        f.WriteInteger(s, 'NumberOfEnclosures', 1);
        f.WriteInteger(s, 'Enclosure001', Enclosures.IndexOf(GetManual(a)) + 1);
      end else
        f.WriteInteger(s, 'NumberOfEnclosures', 0);
      if GetManual(a).FHasTremulant and GetManual(a).FTremulant.FDisplayed then begin
        f.WriteInteger(s, 'NumberOfTremulants', 1);
        f.WriteInteger(s, 'Tremulant001', Tremulants.IndexOf(GetManual(a).Tremulant) + 1);
      end else
        f.WriteInteger(s, 'NumberOfTremulants', 0);
    end;

    for a := 0 to Stops.Count - 1 do
      with TStop(Stops[a]) do begin
        SetExportProgress(a / (Stops.Count + Ranks.Count));
        if Assigned(AInterrupt) and AInterrupt^ then
          Break;
        s := Format('Stop%.3d', [a + 1]);
        f.WriteString(s, 'Name', FName);
        if FRanks.Count > 1 then
          f.WriteInteger(s, 'NumberOfRanks', FRanks.Count);
        if FManual.FFirstKey < FMinFirstPipe then begin
          f.WriteInteger(s, 'FirstAccessiblePipeLogicalKeyNumber', FMinFirstPipe - FManual.FFirstKey + 1);
          b := FMinFirstPipe;
        end else begin
          f.WriteInteger(s, 'FirstAccessiblePipeLogicalKeyNumber', 1);
          b := FManual.FFirstKey;
        end;
        if FManual.FFirstKey + FManual.FNumberOfKeys - 1 > FMaxLastPipe then
          c := FMaxLastPipe
        else
          c := FManual.FFirstKey + FManual.FNumberOfKeys - 1;
        if c - b + 1 < 1 then
          f.WriteInteger(s, 'NumberOfAccessiblePipes', 1)
        else
          f.WriteInteger(s, 'NumberOfAccessiblePipes', c - b + 1);
        if FRanks.Count > 1 then begin
          for d := 0 to FRanks.Count - 1 do begin
            f.WriteInteger(s, Format('Rank%.3d', [d + 1]), Ranks.IndexOf(FRanks[d]) + 1);
            if b > TRank(FRanks[d]).FFirstPipe then begin
              f.WriteInteger(s, Format('Rank%.3dFirstPipeNumber', [d + 1]), b - TRank(FRanks[d]).FFirstPipe + 1);
              f.WriteInteger(s, Format('Rank%.3dFirstAccessibleKeyNumber', [d + 1]), 1);
            end else begin
              f.WriteInteger(s, Format('Rank%.3dFirstPipeNumber', [d + 1]), 1);
              f.WriteInteger(s, Format('Rank%.3dFirstAccessibleKeyNumber', [d + 1]), TRank(FRanks[d]).FFirstPipe - b + 1);
            end;
          end;
        end else begin
          if FManual.FFirstKey > FMinFirstPipe then
            f.WriteInteger(s, 'FirstAccessiblePipeLogicalPipeNumber', FManual.FFirstKey - FMinFirstPipe + 1)
          else
            f.WriteInteger(s, 'FirstAccessiblePipeLogicalPipeNumber', 1);
          f.WriteInteger(s, 'NumberOfLogicalPipes', Rank[0].FNumberOfPipes);
          f.WriteInteger(s, 'WindchestGroup', IndexOfManual(FManual) + 1 - e);
          f.WriteBool(s, 'Percussive', Rank[0].FPercussive);
          f.WriteFloat(s, 'HarmonicNumber', 64 / GHarmonicNumbers[Rank[0].FHarmonicNumber]);
          for b := 0 to Rank[0].FNumberOfPipes - 1 do begin
            f.WriteString(s, Format('Pipe%.3d', [b + 1]), ExtractRelativePath(AFilename, Rank[0].PipeFilename[b]));
            f.WriteBool(s, Format('Pipe%.3dLoadRelease', [b + 1]), False);
            d := 0;
            for c := 0 to Rank[0].FReleases.Count - 1 do
              if Rank[0].GetReleaseEnabled(c) then begin
                Inc(d);
                f.WriteString(s, Format('Pipe%.3dRelease%.3d', [b + 1, d]), ExtractRelativePath(AFilename, Rank[0].ReleaseFilename[b, c]));
                f.WriteInteger(s, Format('Pipe%.3dRelease%.3dCuePoint', [b + 1, d]), 0);
                f.WriteInteger(s, Format('Pipe%.3dRelease%.3dMaxKeyPressTime', [b + 1, d]), Rank[0].ReleaseValue[c]);
              end;
            f.WriteInteger(s, Format('Pipe%.3dReleaseCount', [b + 1]), d);
          end;
        end;
        if FStopFamily.FHasPiston then begin
          f.WriteBool(s, 'Displayed', False);
          f.WriteString(s, 'Function', 'And');
          f.WriteInteger(s, 'SwitchCount', 2);
          f.WriteInteger(s, 'Switch001', Switches.IndexOf(Piston[FManual, FStopFamily]) + 1);
          f.WriteInteger(s, 'Switch002', Switches.IndexOf(Stops[a]) + 1);
        end else begin
          f.WriteBool(s, 'DefaultToEngaged', False);
          f.WriteBool(s, 'Displayed', True);
          f.WriteBool(s, 'DisplayAsPiston', FPiston);
          if FPiston then begin
            f.WriteInteger(s, 'DispButtonCol', FPosition.X);
            f.WriteInteger(s, 'DispButtonRow', FPosition.Y);
            f.WriteInteger(s, 'DispImageNum', FStopFamily.FPistonImage + 1);
            f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FPistonFontSize);
          end else begin
            f.WriteInteger(s, 'DispDrawstopCol', FPosition.X);
            f.WriteInteger(s, 'DispDrawstopRow', FPosition.Y);
            f.WriteInteger(s, 'DispImageNum', FStopFamily.FDrawstopImage + 1);
            f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FDrawstopFontSize);
          end;
          f.WriteString(s, 'DispLabelColour', FStopFamily.GETODFFontColor);
          f.WriteString(s, 'DispLabelFontName', FStopFamily.FFontName);
        end;
      end;

    for a := 0 to Ranks.Count - 1 do
      with TRank(Ranks[a]) do begin
        SetExportProgress((Stops.Count + a) / (Stops.Count + Ranks.Count));
        if Assigned(AInterrupt) and AInterrupt^ then
          Break;
        s := Format('Rank%.3d', [a + 1]);
        if FChannelAssignment <> caNone then
          f.WriteString(s, 'Name', FStop.FName + ' [' + GChannelNames[FChannelAssignment] + ']')
        else
          f.WriteString(s, 'Name', FStop.FName + ' #' + IntToStr(FStop.FRanks.IndexOf(Ranks[a]) + 1));
        f.WriteInteger(s, 'FirstMidiNoteNumber', FFirstPipe);
        f.WriteInteger(s, 'NumberOfLogicalPipes', FNumberOfPipes);
        f.WriteInteger(s, 'WindchestGroup', IndexOfManual(FStop.FManual) + 1 - e);
        f.WriteBool(s, 'Percussive', FPercussive);
        f.WriteFloat(s, 'HarmonicNumber', 64 / GHarmonicNumbers[FHarmonicNumber]);
        for b := 0 to FNumberOfPipes - 1 do begin
          f.WriteString(s, Format('Pipe%.3d', [b + 1]), ExtractRelativePath(AFilename, PipeFilename[b]));
          f.WriteBool(s, Format('Pipe%.3dLoadRelease', [b + 1]), False);
          d := 0;
          for c := 0 to FReleases.Count - 1 do
            if GetReleaseEnabled(c) then begin
              Inc(d);
              f.WriteString(s, Format('Pipe%.3dRelease%.3d', [b + 1, d]), ExtractRelativePath(AFilename, ReleaseFilename[b, c]));
              f.WriteInteger(s, Format('Pipe%.3dRelease%.3dCuePoint', [b + 1, d]), 0);
              f.WriteInteger(s, Format('Pipe%.3dRelease%.3dMaxKeyPressTime', [b + 1, d]), ReleaseValue[c]);
            end;
          f.WriteInteger(s, Format('Pipe%.3dReleaseCount', [b + 1]), d);
        end;
      end;

    for a :=0 to Couplers.Count - 1 do
      with TCoupler(Couplers[a]) do begin
        s := Format('Coupler%.3d', [a + 1]);
        f.WriteString(s, 'Name', GetName);
        if (FSource = FDestination) and (FDelta = cdUnison) then begin
          f.WriteBool(s, 'UnisonOff', True);
          f.WriteBool(s, 'DisplayInInvertedState', True);
          f.WriteBool(s, 'DefaultToEngaged', False);
          f.WriteInteger(s, 'DestinationManual', FManuals.IndexOf(FDestination) + 1);
        end else begin
          f.WriteBool(s, 'UnisonOff', False);
          f.WriteBool(s, 'DefaultToEngaged', False);
          f.WriteInteger(s, 'DestinationManual', FManuals.IndexOf(FDestination) + 1);
          f.WriteInteger(s, 'DestinationKeyshift', 12 * (Integer(FDelta) - 1));
          f.WriteBool(s, 'CoupleToSubsequentUnisonIntermanualCouplers', False);
          f.WriteBool(s, 'CoupleToSubsequentUpwardIntermanualCouplers', False);
          f.WriteBool(s, 'CoupleToSubsequentDownwardIntermanualCouplers', False);
          f.WriteBool(s, 'CoupleToSubsequentUpwardIntramanualCouplers', False);
          f.WriteBool(s, 'CoupleToSubsequentDownwardIntramanualCouplers', False);
        end;
        f.WriteBool(s, 'Displayed', True);
        f.WriteBool(s, 'DisplayAsPiston', FPiston);
        if FPiston then begin
          f.WriteInteger(s, 'DispButtonCol', FPosition.X);
          f.WriteInteger(s, 'DispButtonRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FCouplers.FPistonImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FCouplers.FPistonFontSize);
        end else begin
          f.WriteInteger(s, 'DispDrawstopCol', FPosition.X);
          f.WriteInteger(s, 'DispDrawstopRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FCouplers.FDrawstopImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FCouplers.FDrawstopFontSize);
        end;
        f.WriteString(s, 'DispLabelColour', FCouplers.GetODFFontColor);
        f.WriteString(s, 'DispLabelFontName', FCouplers.FFontName);
      end;

    for a :=0 to Enclosures.Count - 1 do
      with TManual(Enclosures[a]) do begin
        s := Format('Enclosure%.3d', [a + 1]);
        f.WriteString(s, 'Name', FName);
        f.WriteInteger(s, 'AmpMinimumLevel', FEnclosureMinimumLevel);
        if FEnclosures.FImage > 0 then
          f.WriteInteger(s, 'EnclosureStyle', FEnclosures.FImage + 1);
        f.WriteInteger(s, 'DispLabelFontSize', FEnclosures.FFontSize);
        f.WriteString(s, 'DispLabelColour', FEnclosures.GETODFFontColor);
        f.WriteString(s, 'DispLabelFontName', FEnclosures.FFontName);
      end;

    for a :=0 to Tremulants.Count - 1 do
      with TTremulant(Tremulants[a]) do begin
        s := Format('Tremulant%.3d', [a + 1]);
        if FPiston then
          f.WriteString(s, 'Name', 'Trem. ' + FManual.AbbreviatedName)
        else
          f.WriteString(s, 'Name', GetName);
        f.WriteInteger(s, 'Period', FPeriod);
        f.WriteInteger(s, 'StartRate', FStartRate);
        f.WriteInteger(s, 'StopRate', FStopRate);
        f.WriteInteger(s, 'AmpModDepth', FAmpModDepth);
        f.WriteBool(s, 'DefaultToEngaged', False);
        f.WriteBool(s, 'Displayed', True);
        f.WriteBool(s, 'DisplayAsPiston', FPiston);
        if FPiston then begin
          f.WriteInteger(s, 'DispButtonCol', FPosition.X);
          f.WriteInteger(s, 'DispButtonRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FTremulants.FPistonImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FTremulants.FPistonFontSize);
        end else begin
          f.WriteInteger(s, 'DispDrawstopCol', FPosition.X);
          f.WriteInteger(s, 'DispDrawstopRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FTremulants.FDrawstopImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FTremulants.FDrawstopFontSize);
        end;
        f.WriteString(s, 'DispLabelColour', FTremulants.GetODFFontColor);
        f.WriteString(s, 'DispLabelFontName', FTremulants.FFontName);
      end;

    for a :=0 to Switches.Count - 1 do begin
      s := Format('Switch%.3d', [a + 1]);
      if TObject(Switches[a]) is TPiston then
        with TPiston(Switches[a]) do begin
          if FPiston then
            f.WriteString(s, 'Name', 'Trem. ' + FManual.AbbreviatedName)
          else
            f.WriteString(s, 'Name', GetName);
          f.WriteBool(s, 'DefaultToEngaged', False);
          f.WriteBool(s, 'Displayed', False);
        end;
      if TObject(Switches[a]) is TStop then
        with TStop(Switches[a]) do begin
          f.WriteString(s, 'Name', FName);
          f.WriteBool(s, 'DefaultToEngaged', False);
          f.WriteBool(s, 'Displayed', True);
          f.WriteBool(s, 'DisplayAsPiston', FPiston);
          if FPiston then begin
            f.WriteInteger(s, 'DispButtonCol', FPosition.X);
            f.WriteInteger(s, 'DispButtonRow', FPosition.Y);
            f.WriteInteger(s, 'DispImageNum', FStopFamily.FPistonImage + 1);
            f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FPistonFontSize);
          end else begin
            f.WriteInteger(s, 'DispDrawstopCol', FPosition.X);
            f.WriteInteger(s, 'DispDrawstopRow', FPosition.Y);
            f.WriteInteger(s, 'DispImageNum', FStopFamily.FDrawstopImage + 1);
            f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FDrawstopFontSize);
          end;
          f.WriteString(s, 'DispLabelColour', FStopFamily.GETODFFontColor);
          f.WriteString(s, 'DispLabelFontName', FStopFamily.FFontName);
        end;
    end;

    for a :=0 to Pistons.Count - 1 do
      with TPiston(Pistons[a]) do begin
        s := Format('ReversiblePiston%.3d', [a + 1]);
        f.WriteString(s, 'Name', GetName);
        f.WriteString(s, 'ObjectType', 'SWITCH');
        f.WriteInteger(s, 'ObjectNumber', Switches.IndexOf(Pistons[a]) + 1);
        f.WriteBool(s, 'Displayed', True);
        f.WriteBool(s, 'DisplayAsPiston', FPiston);
        if FPiston then begin
          f.WriteInteger(s, 'DispButtonCol', FPosition.X);
          f.WriteInteger(s, 'DispButtonRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FStopFamily.FPistonImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FPistonFontSize);
        end else begin
          f.WriteInteger(s, 'DispDrawstopCol', FPosition.X);
          f.WriteInteger(s, 'DispDrawstopRow', FPosition.Y);
          f.WriteInteger(s, 'DispImageNum', FStopFamily.FDrawstopImage + 1);
          f.WriteInteger(s, 'DispLabelFontSize', FStopFamily.FDrawstopFontSize);
        end;
        f.WriteString(s, 'DispLabelColour', FStopFamily.GETODFFontColor);
        f.WriteString(s, 'DispLabelFontName', FStopFamily.FFontName);
      end;

    for a := 0 to Labels.Count - 1 do begin
      s := Format('Label%.3d', [a + 1]);
      b := Integer(Labels.Objects[a]);
      f.WriteString(s, 'Name', Labels[a]);
      f.WriteBool(s, 'FreeXPlacement', False);
      f.WriteBool(s, 'FreeYPlacement', False);
      f.WriteBool(s, 'DispAtTopOfDrawstopCol', b and $1000 = 0);
      f.WriteInteger(s, 'DispDrawstopCol', 1 + (b and $FF));
      f.WriteBool(s, 'DispSpanDrawstopColToRight', b and $100 <> 0);
      f.WriteInteger(s, 'DispImageNum', FLayout.FLabels.FImage + 1);
      f.WriteInteger(s, 'DispLabelFontSize', FLayout.FLabels.FFontSize);
      f.WriteString(s, 'DispLabelColour', FLayout.FLabels.GetODFFontColor);
      f.WriteString(s, 'DispLabelFontName', FLayout.FLabels.FFontName);
    end;

   if not Assigned(AInterrupt) or not AInterrupt^ then
      f.UpdateFile;
  finally
    Labels.Destroy;
    Pistons.Destroy;
    Tremulants.Destroy;
    Enclosures.Destroy;
    Couplers.Destroy;
    Switches.Destroy;
    Ranks.Destroy;
    Stops.Destroy;
    f.Destroy;
  end;
end;  

function TOrgan.GetInfo(const Index: Integer): string;
begin
  Result := FInfos[Index];
end;

procedure TOrgan.SetInfo(const Index: Integer; const Value: string);
begin
  FInfos[Index] := Value;
end;

procedure TOrgan.MarkModified;
begin
  FModified := True;
end;

procedure TOrgan.SaveToFile(StoreRelativePaths: Boolean);
begin
  Assert(FFilename <> '');
  SaveToFile(FFilename, StoreRelativePaths);
end;

function TOrgan.GetScanPath: string;
begin
  FSection.Enter;
  try
    Result := FScanPath;
  finally
    FSection.Leave;
  end;
end;

function TOrgan.GetExportProgress: Double;
begin
  FSection.Enter;
  try
    Result := FExportProgress;
  finally
    FSection.Leave;
  end;
end;

procedure TOrgan.SetExportProgress(const Value: Double);
begin
  FSection.Enter;
  try
    FExportProgress := Value;
  finally
    FSection.Leave;
  end;
end;

procedure TOrgan.Inspect(AFilename: string);
var
  a, b, c, n: Integer;

  function SameDrive(s, t: string) : Boolean;
  begin
    Result := (s = '') or (t = '') or SameFilename(ExtractFileDrive(s), ExtractFileDrive(t));
  end;

  procedure AddWarning(FormatStr: string; Args: array of TVarRec);
  begin
    FWarnings.Add(Format(FormatStr, Args));
    Inc(n);
  end;

begin
  FWarnings.Clear;
  n := 0;
  FLayout.Resize;
//  if not SameDrive(InfoFilename, AFileName) then
//    AddWarning(S_Warnings[0], [InfoFilename]);
  if (FLayout.FPanelSize.cx in [1 .. 4]) and (GDefaultPanelSizes[FLayout.FPanelSize.cx].cx < FLayout.FAutoSize.cx) then
    AddWarning(S_Warnings[1], [GSizeNames[FLayout.FPanelSize.cx]]);
  if (FLayout.FPanelSize.cy in [1 .. 4]) and (GDefaultPanelSizes[FLayout.FPanelSize.cy].cy < FLayout.FAutoSize.cy) then
    AddWarning(S_Warnings[2], [GSizeNames[FLayout.FPanelSize.cy]]);
  for a := 0 to FRanks.Count - 1 do
    with TRank(FRanks[a]) do
      if Assigned(FStop) then begin
        if not SameDrive(FPath, AFilename) then
          AddWarning(S_Warnings[3], [FPath]);
        for b := 0 to FNumberOfPipes - 1 do begin
          if not FileExists(GetPipeFilename(b)) then
            AddWarning(S_Warnings[4], [GetPipeFilename(b)]);
          for c := 0 to FReleases.Count - 1 do
            if GetReleaseEnabled(c) and not FileExists(GetReleaseFilename(b, c)) then
              AddWarning(S_Warnings[5], [GetReleaseFilename(b, c)]);
        end;
      end;
  for a := 0 to FPistons.Count - 1 do
    with FPistons[a] as TPiston do
      UpdateLayout;
  for a := 0 to FStops.Count - 1 do
    with FStops[a] as TStop do begin
      UpdateLayout;
      if FDisplayed then begin
        if FRanks.Count = 0 then
          AddWarning(S_Warnings[6], [FName, FManual.FName])
        else begin
          if StopFamily.FHasPiston and not GetPiston(FManual, FStopFamily).FDisplayed then
            AddWarning(S_Warnings[7], [FName, FManual.FName, FStopFamily.FName]);
        end;
      end else
        AddWarning(S_Warnings[8], [FName, FManual.FName]);
    end;
  if Assigned(FPedalboard) then
    a := 0
  else
    a := 1;
  for a := a to FManuals.Count do
    if GetManual(a).FHasTremulant then
      with GetManual(a).FTremulant do begin
        UpdateLayout;
        if not FDisplayed then
          AddWarning(S_Warnings[9], [GetManual(a).FName]);
      end;
  if n > 0 then begin
    FWarnings.Insert(0, Format(S_Warnings[10], [n]));
    FWarnings.Insert(1, S_Warnings[11]);
    FWarnings.Insert(2, '');
  end;
end;

{ TOrganObject }

constructor TOrganObject.Create(AOwner: TOrgan);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TSwitch }

procedure TSwitch.UpdateLayout;
//var
//  a: Integer;
begin
  FPiston := False;
  FDisplayed := FOwner.FLayout.FLeftMatrix.Contains(Self, FPosition);
  if not FDisplayed then begin
    FDisplayed := FOwner.FLayout.FRightMatrix.Contains(Self, FPosition);
    Inc(FPosition.X, FOwner.FLayout.FSideMatrixSize.cx);
  end;
  Inc(FPosition.Y);
  if not FDisplayed then begin
    FDisplayed := FOwner.FLayout.FCenterMatrix.Contains(Self, FPosition);
    Inc(FPosition.Y, 100);
  end;
  if not FDisplayed then begin
    FDisplayed := FOwner.FLayout.FPistonMatrix.Contains(Self, FPosition);
    if FPosition.Y - FOwner.FLayout.FTopPistonMatrixHeight >= FOwner.FManuals.Count then begin
      if FPosition.Y - FOwner.FLayout.FTopPistonMatrixHeight > FOwner.FManuals.Count then
        FPosition.Y := 0
      else
        FPosition.Y := 99
    end else begin
      if FPosition.Y < FOwner.FLayout.FTopPistonMatrixHeight then
        FPosition.Y := 100 + FPosition.Y
      else begin
        FPosition.Y := FOwner.FLayout.FPistonMatrix.Height - FPosition.Y - FOwner.FLayout.FBottomPistonMatrixHeight;
//        for a := 1 to FOwner.FManuals.Count do
//          if FOwner.GetManual(a).FInvisible then
//            Inc(FPosition.Y);
      end;
    end;
    FPiston := True;
  end;
  Inc(FPosition.X);
end;

{ TCaptionStyle }

procedure TCaptionStyle.Clear;
begin
  FFontName := GDefaultFontName;
  FFontColor := 0;
end;

function TCaptionStyle.GETODFFontColor: string;
begin
  if FFontColor < 0 then
    Result := GColorNames[- FFontColor]
  else
    Result := '#' + IntToHex(GetRValue(FFontColor), 2) + IntToHex(GetGValue(FFontColor), 2) + IntToHex(GetBValue(FFontColor), 2);
end;

function TCaptionStyle.GetRGBFontColor: TColor;
begin
  if FFontColor < 0 then
    Result := GColors[- FFontColor]
  else
    Result := FFontColor;
end;

procedure TCaptionStyle.LoadFromFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  FFontName := AFile.ReadString(ASection, AName + 'FontName', FFontName);
  if Screen.Fonts.IndexOf(FFontName) = - 1 then begin
    FOwner.FFontWarning := True;
    FFontName := GDefaultFontName;
  end;
  FFontColor := AFile.ReadInteger(ASection, AName + 'FontColor', FFontColor);
end;

procedure TCaptionStyle.SaveToFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  AFile.WriteString(ASection, AName + 'FontName', FFontName);
  AFile.WriteInteger(ASection, AName + 'FontColor', FFontColor);
end;

{ TButtonStyle }

procedure TButtonStyle.Clear;
begin
  inherited;
  FDrawstopImage := 0;
  FPistonImage := 0;
  FDrawstopFontSize := 10;
  FPistonFontSize := 7;
end;

procedure TButtonStyle.LoadFromFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  FDrawstopImage := AFile.ReadInteger(ASection, AName + 'DrawstopImage', FDrawstopImage);
  FPistonImage := AFile.ReadInteger(ASection, AName + 'PistonImage', FPistonImage);
  FDrawstopFontSize := AFile.ReadInteger(ASection, AName + 'DrawstopFontSize', FDrawstopFontSize);
  FPistonFontSize := AFile.ReadInteger(ASection, AName + 'PistonFontSize', FPistonFontSize);
end;

procedure TButtonStyle.SaveToFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  AFile.WriteInteger(ASection, AName + 'DrawstopImage', FDrawstopImage);
  AFile.WriteInteger(ASection, AName + 'PistonImage', FPistonImage);
  AFile.WriteInteger(ASection, AName + 'DrawstopFontSize', FDrawstopFontSize);
  AFile.WriteInteger(ASection, AName + 'PistonFontSize', FPistonFontSize);
end;

{ TCouplers }

procedure TCouplers.Clear;
begin
  inherited;
  FFontColor := - 4;
end;

constructor TCouplers.Create(AOwner: TOrgan);
begin
  inherited;
  FCouplers := TObjectList.Create(True);
end;

destructor TCouplers.Destroy;
begin
  FreeAndNil(FCouplers);
  inherited;
end;

function TCouplers.GetCoupler(ASource, ADestination: TManual;
  ADelta: TCouplerDelta): TCoupler;
var
  a: Integer;
begin
  Result := nil;
  for a := 0 to FCouplers.Count - 1 do
    with FCouplers[a] as TCoupler do
      if (FSource = ASource) and (FDestination = ADestination) and (FDelta = ADelta) then
        Result := FCouplers[a] as TCoupler;
  Assert(Assigned(Result));
end;

procedure TCouplers.Update;
var
  a, b, c, e: Integer;
  d: TCouplerDelta;
  t: Boolean;
begin
  for a := FCouplers.Count - 1 downto 0 do begin
    with FCouplers[a] as TCoupler do begin
      b := FOwner.FManuals.IndexOf(FSource);
      c := FOwner.FManuals.IndexOf(FDestination);
      t := (b = - 1) and (FSource <> FOwner.FPedalboard) or (c = - 1) and (FDestination <> FOwner.FPedalboard);
    end;
    if t or not (FCouplers[a] as TCoupler).FActive or (FCouplers[a] as TCoupler).FSource.FInvisible then begin
      FOwner.FLayout.FLeftMatrix.Remove(FCouplers[a]);
      FOwner.FLayout.FRightMatrix.Remove(FCouplers[a]);
      FOwner.FLayout.FCenterMatrix.Remove(FCouplers[a]);
      FOwner.FLayout.FPistonMatrix.Remove(FCouplers[a]);
    end;
    if t then
      FCouplers.Delete(a);
  end;
  if Assigned(FOwner.FPedalBoard) then
    a := 0
  else
    a := 1;
  for b := a to FOwner.FManuals.Count do
    for c := a to FOwner.FManuals.Count do
      for d := cdMinus8 to cdPlus8 do begin
        t := False;
        for e := 0 to FCouplers.Count - 1 do
          with FCouplers[e] as TCoupler do
            t := t or (FSource = FOwner.GetManual(b)) and (FDestination = FOwner.GetManual(c)) and (FDelta = d);
        if not t then
          FCouplers.Add(TCoupler.Create(FOwner, FOwner.GetManual(b), FOwner.GetManual(c), d, ((b < c) or (b = 1) and (c = 1)) and (d = cdUnison)));
      end;
end;

{ TTremulants }

procedure TTremulants.Clear;
begin
  inherited;
  FFontColor := - 2;
end;

{ TLabelStyle }

procedure TLabelStyle.Clear;
begin
  inherited;
  FFontSize := 9;
end;

procedure TLabelStyle.LoadFromFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  FImage := AFile.ReadInteger(ASection, AName + 'Image', FImage);
  FFontSize := AFile.ReadInteger(ASection, AName + 'FontSize', FFontSize);
end;

procedure TLabelStyle.SaveToFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  AFile.WriteInteger(ASection, AName + 'Image', FImage);
  AFile.WriteInteger(ASection, AName + 'FontSize', FFontSize);
end;

{ TManual }

constructor TManual.Create(AOwner: TOrgan; Index: Integer);
begin
  inherited Create(AOwner);
  FStops := TList.Create;
  FCouplers := TManualCouplers.Create(AOwner);
  case Index of
    Low(S_ManualNames) .. High(S_ManualNames) - 1: begin
      FName := S_ManualNames[Index];
    end;
  else
    FName := Format(S_ManualNames[High(S_ManualNames)], [Index]);
  end;
  FAbbreviatedName := GRomanNumerals[Index];
  if Index = 0 then
    FNumberOfKeys := 32
  else
    FNumberOfKeys := 61;
  FFirstKey := 36;
  FTremulant := TTremulant.Create(Self);
  FEnclosureMinimumLevel := 20;
end;

destructor TManual.Destroy;
begin
  if Assigned(FOwner.FLayout) then begin
    FOwner.FLayout.FLeftMatrix.Remove(FTremulant);
    FOwner.FLayout.FRightMatrix.Remove(FTremulant);
    FOwner.FLayout.FCenterMatrix.Remove(FTremulant);
    FOwner.FLayout.FPistonMatrix.Remove(FTremulant);
  end;
  FreeAndNil(FTremulant);
  FreeAndNil(FCouplers);
  FreeAndNil(FStops);
  inherited;
end;

function TManual.GetNumberOfStops: Integer;
begin
  Result := FStops.Count;
end;

function TManual.GetStop(const Index: Integer): TStop;
begin
  Result := TStop(FStops[Index]);
end;

procedure TManual.SetHasTremulant(const Value: Boolean);
begin
  FHasTremulant := Value;
  if not Value then begin
    FOwner.FLayout.FLeftMatrix.Remove(FTremulant);
    FOwner.FLayout.FRightMatrix.Remove(FTremulant);
    FOwner.FLayout.FCenterMatrix.Remove(FTremulant);
    FOwner.FLayout.FPistonMatrix.Remove(FTremulant);
  end;
end;

procedure TManual.SetInvisible(const Value: Boolean);
var
  a: Integer;
  d: TCouplerDelta;
begin
  FInvisible := Value;
  if Value then begin
    if Assigned(FOwner.FPedalboard) then
      a := 0
    else
      a := 1;
    for a := a to FOwner.NumberOfManuals do
      for d := cdMinus8 to cdPlus8 do
        FOwner.Couplers[Self, FOwner.GetManual(a), d].FActive := False;
  end;
  FOwner.UpdatePistons;
  FOwner.FCouplers.Update;
end;

{ TCoupler }

constructor TCoupler.Create(AOwner: TOrgan; ASource, ADestination: TManual;
  ADelta: TCouplerDelta; AActive: Boolean);
begin
  inherited Create(AOwner);
  FSource := ASource;
  FDestination := ADestination;
  FDelta := ADelta;
  FActive := AActive;
end;

function TCoupler.GetName: string;
//var
//  a, b: Integer;
const
  t: array[cdMinus8 .. cdPlus8] of string = ('16'' ', '', '4'' ');
begin
//  a := FOwner.IndexOfManual(FSource);
//  b := FOwner.IndexOfManual(FDestination);
  Result := t[FDelta] + FDestination.FAbbreviatedName + '/' + FSource.FAbbreviatedName;
end;

procedure TCoupler.SetActive(const Value: Boolean);
begin
  FActive := Value;
  FOwner.FCouplers.Update;
end;

{ TTremulant }

constructor TTremulant.Create(AManual: TManual);
begin
  inherited Create(AManual.FOwner);
  FManual := AManual;
  FPeriod := 180;
  FStartRate := 6;
  FStopRate := 6;
  FAmpModDepth := 15;
end;

function TTremulant.GetName: string;
begin
  Result := 'Tremulant ' + FManual.Name;
end;

{ TStopFamily }

constructor TStopFamily.Create(AOwner: TOrgan; Index: Integer);
begin
  inherited Create(AOwner);
  case Index of
    0: begin
      FName := S_StopFamilyNames[0];
      FFontColor := 0;
    end;
    1: begin
      FName := S_StopFamilyNames[1];
      FFontColor := -8;
      FHasPiston := True;
    end;
  else
    FName := Format(S_StopFamilyNames[2], [Index + 1]);
    FFontColor := -4;
  end;
  FDrawstopImage := 0;
  FPistonImage := 0;
  FFontName := GDefaultFontName;
  FDrawstopFontSize := 10;
  FPistonFontSize := 7;
end;

procedure TStopFamily.LoadFromFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  FName := AFile.ReadString(ASection, 'Name', FName);
  FHasPiston := AFile.ReadBool(ASection, 'HasPiston', FHasPiston);
end;

procedure TStopFamily.SaveToFile(AFile: TCustomIniFile; ASection,
  AName: string);
begin
  inherited;
  AFile.WriteString(ASection, 'Name', FName);
  AFile.WriteBool(ASection, 'HasPiston', FHasPiston);
end;

procedure TStopFamily.SetHasPiston(const Value: Boolean);
begin
  FHasPiston := Value;
  FOwner.UpdatePistons;
end;

{ TPiston }

constructor TPiston.Create(AOwner: TOrgan; AManual: TManual;
  AStopFamily: TStopFamily);
begin
  inherited Create(AOwner);
  FManual := AManual;
  FStopFamily := AStopFamily;
end;

function TPiston.GetName: string;
begin
  Result := FStopFamily.Name + ' ' + FManual.FName;
end;

{ TStop }

constructor TStop.Create(AOwner: TOrgan; AName: string);
begin
  Create(AOwner);
  FName := AName;
end;

constructor TStop.Create(AOwner: TOrgan);
begin
  inherited Create(AOwner);
  FRanks := TList.Create;
end;

destructor TStop.Destroy;
begin
  FreeAndNil(FRanks);
  inherited;
end;

function TStop.GetNumberOfRanks: Integer;
begin
  Result := FRanks.Count;
end;

function TStop.GetRank(const Index: Integer): TRank;
begin
  Result := TRank(FRanks[Index]);
end;

function TStop.IndexOfRank(ARank: TRank): Integer;
begin
  Result := FRanks.IndexOf(ARank);
end;

procedure TStop.InsertRank(ARank: TRank; AIndex: Integer);
begin
  if Assigned(ARank.FStop) then begin
    ARank.FStop.FRanks.Remove(ARank);
    ARank.FStop := nil;
  end;
  FRanks.Insert(AIndex, ARank);
  ARank.FStop := Self;
end;

procedure TStop.RemoveRank(ARank: TRank);
var
  a: Integer;
begin
  a := FRanks.IndexOf(ARank);
  Assert(a > -1);
  FRanks.Delete(a);
  ARank.FStop := nil;
end;

{ TRank }

constructor TRank.Create(AOwner: TOrgan; APath: string; AFirstPipe,
  ANumberOfPipes: Integer; AReleasePaths: array of string;
  AReleaseValues: array of Integer);
var
  a: Integer;
begin
  Create(AOwner);
  FPath := APath;
  FFirstPipe := AFirstPipe;
  FNumberOfPipes := ANumberOfPipes;
  Assert((High(AReleasePaths)=High(AReleaseValues)) and (Low(AReleasePaths)=Low(AReleaseValues)));
  for a := Low(AReleasePaths) to High(AReleasePaths) do
    FReleases.AddObject(AReleasePaths[a], TObject(AReleaseValues[a]));
end;

constructor TRank.Create(AOwner: TOrgan);
begin
  inherited Create(AOwner);
  FReleases := TStringList.Create;
  FReleases.Sorted := True;
  FHarmonicNumber := 3;
end;

destructor TRank.Destroy;
begin
  FreeAndNil(FReleases);
  inherited;
end;

function TRank.GetNumberOfReleases: Integer;
begin
  Result := FReleases.Count;
end;

function TRank.GetPipeFilename(const Index: Integer): string;
begin
  Result := FPath + '\0' + IntToStr(FFirstPipe + Index) + '-' + GKeyNames[(FFirstPipe + Index + 3) mod 12] + '.wav';
end;

function TRank.GetReleaseEnabled(const Index: Integer): Boolean;
begin
  Result := Integer(FReleases.Objects[Index]) > 0;
end;

function TRank.GetReleaseFilename(const Index, Release: Integer): string;
begin
  Result := FPath + '\' + FReleases[Release] + '\0' + IntToStr(FFirstPipe + Index) + '-' + GKeyNames[(FFirstPipe + Index + 3) mod 12] + '.wav';
end;

function TRank.GetReleasePath(const Index: Integer): string;
begin
  Result := FReleases[Index];
end;

function TRank.GetReleaseValue(const Index: Integer): Integer;
begin
  Result := Abs(Integer(FReleases.Objects[Index]));
end;

procedure TRank.SetReleaseEnabled(const Index: Integer;
  const Value: Boolean);
begin
  if Value then
    FReleases.Objects[Index] := TObject(Abs(Integer(FReleases.Objects[Index])))
  else
    FReleases.Objects[Index] := TObject(- Abs(Integer(FReleases.Objects[Index])));
end;

{ TObjectMatrix }

procedure TObjectMatrix.Clear(DeleteObjects: Boolean);
var
  a: Integer;
begin
  for a := 0 to FData.Count - 1 do begin
    if DeleteObjects then
      TObject(FData[a]).Free;
    FData[a] := nil;
  end;
end;

function TObjectMatrix.Contains(AItem: TObject): Boolean;
begin
  Result := FData.IndexOf(AItem) > - 1;
end;

function TObjectMatrix.Contains(AItem: TObject;
  var APosition: TPoint): Boolean;
var
  a: Integer;
begin
  a := FData.IndexOf(AItem);
  Result := a > - 1;
  if a > - 1 then begin
    APosition.X := a mod FWidth;
    APosition.Y := a div FWidth;
  end;
end;

constructor TObjectMatrix.Create;
begin
  inherited Create;
  FData := TList.Create;
end;

procedure TObjectMatrix.DeleteLine(Index: Integer);
var
  a: Integer;
begin
  for a := FWidth - 1 downto 0 do
    FData.Delete(FWidth * Index + a);
  Dec(FHeight);
end;

destructor TObjectMatrix.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TObjectMatrix.GetValue(const X, Y: Integer): TObject;
begin
  Result := TObject(FData[x + Y * FWidth]);
end;

procedure TObjectMatrix.InsertLine(Index: Integer);
var
  a: Integer;
begin
  for a := 0 to FWidth - 1 do
    FData.Insert(FWidth * Index + a, nil);
  Inc(FHeight);
end;

procedure TObjectMatrix.Remove(AItem: TObject);
var
  a: Integer;
begin
  a := FData.IndexOf(AItem);
  if a > - 1 then
    FData[a] := nil;
  Assert(FData.IndexOf(AItem) = - 1);
end;

procedure TObjectMatrix.Resize(AWidth, AHeight: Integer);
var
  a, b, c, d: Integer;
  l: TList;
begin
  if (AWidth <> FWidth) or (AHeight <> FHeight) then begin
    l := TList.Create;
    for a := 0 to AWidth * AHeight - 1 do
      l.Add(nil);
    c := AWidth;
    d := AHeight;
    if c > FWidth then
      c := FWidth;
    if d > FHeight then
      d := FHeight;
    for a := 0 to c - 1 do
      for b := 0 to d - 1 do
        l[a + b * AWidth] := FData[a + b * FWidth];
    FData.Destroy;
    FData := l;
    FWidth := AWidth;
    FHeight := AHeight;
  end;
end;

procedure TObjectMatrix.SetValue(const X, Y: Integer;
  const Value: TObject);
var
  a: Integer;
begin
  a := FData.IndexOf(Value);
  if a > - 1 then
    FData[a] := nil;
  FData[x + Y * FWidth] := Value;
end;

{ TODFFile }

procedure TODFFile.WriteBool(const Section, Ident: string; Value: Boolean);
const
  T: array[False .. True] of string = ('N', 'Y');
begin
  WriteString(Section, Ident, T[Value]);
end;

procedure Initialize;
var
  NCM: TNonClientMetrics;
begin
  NCM.cbSize := SizeOf(NCM);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NCM, 0) then
    GDefaultFontName := NCM.lfMessageFont.lfFaceName;
end;

procedure TODFFile.WritePath(const Section, Ident: string; Value: string;
  Absolute: Boolean);
begin
  if not Absolute and SameFilename(ExtractFileDrive(FileName), ExtractFileDrive(Value)) then
    WriteString(Section, Ident, '.\' + ExtractRelativePath(Filename, Value))
  else
    WriteString(Section, Ident, Value);
end;

{ TLabels }

procedure TLabels.Clear;
var
  p: TLabelPosition;
begin
  inherited;
  for p := lpTopLeft to lpBottomRight do
    FLabels[p].Clear;
end;

constructor TLabels.Create(AOwner: TOrgan);
var
  p: TLabelPosition;
begin
  inherited;
  for p := lpTopLeft to lpBottomRight do
    FLabels[p] := TStringList.Create;
end;

destructor TLabels.Destroy;
var
  p: TLabelPosition;
begin
  for p := lpTopLeft to lpBottomRight do
    FreeAndNil(FLabels[p]);
  inherited;
end;

function TLabels.GetLabels(const Position: TLabelPosition): TStrings;
begin
  Result := FLabels[Position];
end;

procedure TLabels.LoadFromFile(AFile: TCustomIniFile; ASection,
  AName: string);
var
  a: Integer;
  p: TLabelPosition;
begin
  inherited;
  for p := lpTopLeft to lpBottomRight do
    for a := 0 to FLabels[p].Count - 1 do
      FLabels[p][a] := AFile.ReadString(ASection, ASection + '.' + GLabelPositionNames[p] + '[' + IntToStr(a) + ']', FLabels[p][a]);
end;

procedure TLabels.SaveToFile(AFile: TCustomIniFile; ASection,
  AName: string);
var
  a: Integer;
  p: TLabelPosition;
begin
  inherited;
  for p := lpTopLeft to lpBottomRight do
    for a := 0 to FLabels[p].Count - 1 do
      if FLabels[p][a] <> '' then
        AFile.WriteString(ASection, ASection + '.' + GLabelPositionNames[p] + '[' + IntToStr(a) + ']', FLabels[p][a]);
end;

{ TLayout }

procedure TLayout.Clear;
begin
  FLeftMatrix.Resize(0, 0);
  FRightMatrix.Resize(0, 0);
  FCenterMatrix.Resize(0, 0);
  SetSideMatrixWidth(3);
  SetSideMatrixHeight(6);
  FCenterMatrix.Resize(5, 3);
  FPairDrawstopCols := False;
  FDrawstopLayout := 0;
  FExtraDrawstopRowsAboveExtraButtonRow := False;

  FPistonMatrix.Resize(0, 0);
  SetPistonMatrixWidth(8);
  SetTopPistonMatrixHeight(0);
  SetBottomPistonMatrixHeight(1);
  FPistonLayout := 0;
  FButtonsAboveManuals := False;

  FLabels.Clear;

  FBackgroundImages[0] := 12;
  FBackgroundImages[1] := 17;
  FBackgroundImages[2] := 22;
  FBackgroundImages[3] := 11;
  FBackgroundImages[4] := 52;
  FTrimAboveManuals := False;
  FTrimBelowManuals := False;
  FTrimAboveExtraRows := False;

  FDefaultButtonSize := True;
  FDrawstopSize.cx := GDefaultDrawstopWidth;
  FDrawstopSize.cy := GDefaultDrawstopHeight;
  FPistonSize.cx := GDefaultPistonWidth;
  FPistonSize.cy := GDefaultPistonHeight;
  FPanelSize.cx := 0;
  FPanelSize.cy := 0;

  Update;
end;

constructor TLayout.Create(AOwner: TOrgan);
begin
  inherited;
  FLeftMatrix := TObjectMatrix.Create;
  FRightMatrix := TObjectMatrix.Create;
  FCenterMatrix := TObjectMatrix.Create;
  FPistonMatrix := TObjectMatrix.Create;
  FLabels := TLabels.Create(FOwner);
end;

destructor TLayout.Destroy;
begin
  FreeAndNil(FLabels);
  FreeAndNil(FPistonMatrix);
  FreeAndNil(FCenterMatrix);
  FreeAndNil(FRightMatrix);
  FreeAndNil(FLeftMatrix);
  inherited;
end;

function TLayout.GetBackgroundImage(const Index: Integer): Integer;
begin
  Result := FBackgroundImages[Index];
end;

function TLayout.GetDrawstopHeight: Integer;
begin
  if FDefaultButtonSize then
    Result :=GDefaultDrawstopHeight
  else
    Result := FDrawstopSize.cy;
end;

function TLayout.GetDrawstopWidth: Integer;
begin
  if FDefaultButtonSize then
    Result :=GDefaultDrawstopWidth
  else
    Result := FDrawstopSize.cx;
end;

function TLayout.GetPistonHeight: Integer;
begin
  if FDefaultButtonSize then
    Result :=GDefaultPistonHeight
  else
    Result := FPistonSize.cy;
end;

function TLayout.GetPistonWidth: Integer;
begin
  if FDefaultButtonSize then
    Result :=GDefaultPistonWidth
  else
    Result := FPistonSize.cx;
end;

function TLayout.IsObjectOnPanel(AObject: TObject): Boolean;
begin
  Result := FLeftMatrix.Contains(AObject) or
            FRightMatrix.Contains(AObject) or
            FCenterMatrix.Contains(AObject) or
            FPistonMatrix.Contains(AObject);
end;

procedure TLayout.LoadFromFile(AFile: TCustomIniFile; ASection: string);
var
  a: Integer;

  procedure ReadMatrix(AMatrix: TObjectMatrix; ASection: string; AKey: string);
  var
    a, b, c: Integer;
    s: string;
  begin
    for a := 0 to AMatrix.FWidth - 1 do
      for b := 0 to AMatrix.FHeight - 1 do begin
        s := AKey + '[' + IntToStr(a) + ',' + IntToStr(b);
        c := AFile.ReadInteger(ASection, s + '].Type', 0);
        case c of
          1: begin
            AMatrix[a, b] := FOwner.FStops[AFile.ReadInteger(ASection, s + '].Stop', - 1)];
          end;
          2: begin
            AMatrix[a, b] := FOwner.FCouplers.GetCoupler(
              FOwner.GetManual(AFile.ReadInteger(ASection, s + '].Source', - 1)),
              FOwner.GetManual(AFile.ReadInteger(ASection, s + '].Destination', - 1)),
              TCouplerDelta(AFile.ReadInteger(ASection, s + '].Delta', 0))
            );
          end;
          3: begin
            AMatrix[a, b] := FOwner.GetPiston(
              FOwner.GetManual(AFile.ReadInteger(ASection, s + '].Manual', - 1)),
              FOwner.FStopFamilies[AFile.ReadInteger(ASection, s + '].Family', - 1)] as TStopFamily
            );
          end;
          4: begin
            AMatrix[a, b] := FOwner.GetManual(AFile.ReadInteger(ASection, s + '].Manual', - 1)).FTremulant;
          end;
        end;
      end;
  end;

begin
  SetSideMatrixWidth(AFile.ReadInteger(ASection, 'SideMatrixWidth', FSideMatrixSize.cx));
  SetSideMatrixHeight(AFile.ReadInteger(ASection, 'SideMatrixHeight', FSideMatrixSize.cy));
  FCenterMatrix.Resize(AFile.ReadInteger(ASection, 'CenterMatrixWidth', FCenterMatrix.Width), AFile.ReadInteger(ASection, 'CenterMatrixHeight', FCenterMatrix.Height));
  SetPairDrawstopCols(AFile.ReadBool(ASection, 'PairDrawstopCols', FPairDrawstopCols));
  ReadMatrix(FLeftMatrix, ASection, 'Left');
  ReadMatrix(FRightMatrix, ASection, 'Right');
  ReadMatrix(FCenterMatrix, ASection, 'Center');
  FDrawstopLayout := AFile.ReadInteger(ASection, 'DrawstopLayout', FDrawstopLayout);
  FExtraDrawstopRowsAboveExtraButtonRow := AFile.ReadBool(ASection, 'ExtraDrawstopRowsAboveExtraButtonRow', FExtraDrawstopRowsAboveExtraButtonRow);

  SetPistonMatrixWidth(AFile.ReadInteger(ASection, 'PistonMatrixWidth', FPistonMatrixWidth));
  SetTopPistonMatrixHeight(AFile.ReadInteger(ASection, 'TopPistonMatrixHeight', FTopPistonMatrixHeight));
  SetBottomPistonMatrixHeight(AFile.ReadInteger(ASection, 'BottomPistonMatrixHeight', FBottomPistonMatrixHeight));
  ReadMatrix(FPistonMatrix, ASection, 'Piston');
  FPistonLayout := AFile.ReadInteger(ASection, 'PistonLayout', FPistonLayout);
  FButtonsAboveManuals := AFile.ReadBool(ASection, 'ButtonsAboveManuals', FButtonsAboveManuals);

  FLabels.LoadFromFile(AFile, ASection, 'Labels');

  for a := 0 to 4 do
    FBackgroundImages[a] := AFile.ReadInteger(ASection, 'BackgroundImage[' + IntToStr(a) + ']', FBackgroundImages[a]);
  FTrimAboveManuals := AFile.ReadBool(ASection, 'TrimAboveManuals', FTrimAboveManuals);
  FTrimBelowManuals := AFile.ReadBool(ASection, 'TrimBelowManuals', FTrimBelowManuals);
  FTrimAboveExtraRows := AFile.ReadBool(ASection, 'TrimAboveExtraRows', FTrimAboveExtraRows);

  FDefaultButtonSize := AFile.ReadBool(ASection, 'DefaultButtonSize', FDefaultButtonSize);
  FDrawstopSize.cx := AFile.ReadInteger(ASection, 'DrawstopWidth', FDrawstopSize.cx);
  FDrawstopSize.cy := AFile.ReadInteger(ASection, 'DrawstopHeight', FDrawstopSize.cy);
  FPistonSize.cx := AFile.ReadInteger(ASection, 'PistonWidth', FPistonSize.cx);
  FPistonSize.cy := AFile.ReadInteger(ASection, 'PistonHeight', FPistonSize.cy);
  FPanelSize.cx := AFile.ReadInteger(ASection, 'PanelWidth', FPanelSize.cx);
  FPanelSize.cy := AFile.ReadInteger(ASection, 'PanelHeight', FPanelSize.cy);
end;

procedure TLayout.Resize;
var
  a, b, c, d: Integer;
  SideDrawstops: TSize;
  CenterDrawstops: TSize;
  Pistons: TSize;
  Enclosures: TSize;
  Manuals: TSize;
begin
  SideDrawStops.cx := FSideMatrixSize.cx * GetDrawstopWidth + 2 * 16;
  if FPairDrawstopCols then
    Inc(SideDrawStops.cx, ((FSideMatrixSize.cx div 2) - 1) * 8);
  SideDrawStops.cy := 2 * 50 + FSideMatrixSize.cy * GetDrawstopHeight;
  if FDrawstopLayout > 0 then
    Inc(SideDrawStops.cy, GetDrawstopHeight div 2);
  CenterDrawstops.cx := FCenterMatrix.Width * GetDrawstopWidth;
  CenterDrawstops.cy := FCenterMatrix.Height * GetDrawstopHeight;
  b := FTopPistonMatrixHeight;
//  if Assigned(FPedalboard) then
    Inc(b, FBottomPistonMatrixHeight);
  for a := 1 to FOwner.FManuals.Count do
    if not FOwner.GetManual(a).FInvisible then
      Inc(b);
  Pistons.cx := FPistonMatrixWidth * GetPistonWidth;
  Pistons.cy := b * GetPistonHeight;
  if (FPistonLayout > 0) and (FBottomPistonMatrixHeight > 1) then
    Inc(Pistons.cx, GetPistonWidth div 2);
  if FTrimAboveExtraRows then
    Inc(Pistons.cy, 8);
  if Assigned(FOwner.FPedalboard) then
    d := 0
  else
    d := 1;
  b := 0;
  for a := d to FOwner.NumberOfManuals do
    if FOwner.GetManual(a).FHasEnclosure then
      Inc(b);
  Enclosures.cx := b * GDefaultEnclosureWidth;
  Enclosures.cy := GDefaultEnclosureHeight + 30;
  Manuals.cx := 0;
  Manuals.cy := 0;
  for a := d to FOwner.NumberOfManuals do
    if a = 0 then begin
      Manuals.cx := FOwner.FPedalboard.FNumberOfKeys * GDefaultPedalKeyWidth;
      Manuals.cy := GDefaultPedalHeight;
    end else begin
      if not FOwner.GetManual(a).FInvisible then begin
        if (a = 1) and FTrimBelowManuals then
          Inc(Manuals.cy, 8);
        if (a = FOwner.FManuals.Count) and FTrimAboveManuals then
          Inc(Manuals.cy, 8);
        c := 0;
        for b := 0 to FOwner.GetManual(a).FNumberOfKeys - 1 do
          case (FOwner.GetManual(a).FFirstKey + b) mod 12 of
            0, 2, 4, 5, 7, 9, 11: Inc(c);
          end;
        c := c * GDefaultManualKeyWidth;
        if c > Manuals.cx then
          Manuals.cx := c;
        Inc(Manuals.cy, GDefaultManualHeight);
      end;
    end;
//  Inc(Manuals.cx, 50);
  FAutoSize.cx := MaxIntValue([CenterDrawstops.cx, Pistons.cx, Enclosures.cx, Manuals.cx]);
  Inc(FAutoSize.cx, SideDrawStops.cx * 2);
  Inc(FAutoSize.cx, 50);
  FAutoSize.cy := MaxIntValue([CenterDrawstops.cy + Pistons.cy + Enclosures.cy + Manuals.cy, SideDrawstops.cy]);
end;

procedure TLayout.SaveToFile(AFile: TCustomIniFile; ASection: string);
var
  a: Integer;

  procedure WriteMatrix(AMatrix: TObjectMatrix; ASection: string; ABaseKey: string);
  var
    a, b: Integer;
    s: string;
  begin
    for a := 0 to AMatrix.FWidth - 1 do
      for b := 0 to AMatrix.FHeight - 1 do begin
        s := ABaseKey + '[' + IntToStr(a) + ',' + IntToStr(b);
        if AMatrix[a, b] is TStop then begin
          AFile.WriteInteger(ASection, s + '].Type', 1);
          AFile.WriteInteger(ASection, s + '].Stop', FOwner.FStops.IndexOf(AMatrix[a, b]));
        end;
        if AMatrix[a, b] is TCoupler then begin
          AFile.WriteInteger(ASection, s + '].Type', 2);
          AFile.WriteInteger(ASection, s + '].Source', FOwner.IndexOfManual((AMatrix[a, b] as TCoupler).FSource));
          AFile.WriteInteger(ASection, s + '].Destination', FOwner.IndexOfManual((AMatrix[a, b] as TCoupler).FDestination));
          AFile.WriteInteger(ASection, s + '].Delta', Integer((AMatrix[a, b] as TCoupler).FDelta));
        end;
        if AMatrix[a, b] is TPiston then begin
          AFile.WriteInteger(ASection, s + '].Type', 3);
          AFile.WriteInteger(ASection, s + '].Manual', FOwner.IndexOfManual((AMatrix[a, b] as TPiston).FManual));
          AFile.WriteInteger(ASection, s + '].Family', FOwner.FStopFamilies.IndexOf((AMatrix[a, b] as TPiston).FStopFamily));
        end;
        if AMatrix[a, b] is TTremulant then begin
          AFile.WriteInteger(ASection, s + '].Type', 4);
          AFile.WriteInteger(ASection, s + '].Manual', FOwner.IndexOfManual((AMatrix[a, b] as TTremulant).FManual));
        end;
      end;
  end;

begin
  AFile.WriteInteger(ASection, 'SideMatrixWidth', FSideMatrixSize.cx);
  AFile.WriteInteger(ASection, 'SideMatrixHeight', FSideMatrixSize.cy);
  AFile.WriteInteger(ASection, 'CenterMatrixWidth', FCenterMatrix.Width);
  AFile.WriteInteger(ASection, 'CenterMatrixHeight', FCenterMatrix.Height);
  AFile.WriteBool(ASection, 'PairDrawstopCols', FPairDrawstopCols);
  WriteMatrix(FLeftMatrix, ASection, 'Left');
  WriteMatrix(FRightMatrix, ASection, 'Right');
  WriteMatrix(FCenterMatrix, ASection, 'Center');
  AFile.WriteInteger(ASection, 'DrawstopLayout', FDrawstopLayout);
  AFile.WriteBool(ASection, 'ExtraDrawstopRowsAboveExtraButtonRow', FExtraDrawstopRowsAboveExtraButtonRow);

  AFile.WriteInteger(ASection, 'PistonMatrixWidth', FPistonMatrixWidth);
  AFile.WriteInteger(ASection, 'TopPistonMatrixHeight', FTopPistonMatrixHeight);
  AFile.WriteInteger(ASection, 'BottomPistonMatrixHeight', FBottomPistonMatrixHeight);
  WriteMatrix(FPistonMatrix, ASection, 'Piston');
  AFile.WriteInteger(ASection, 'PistonLayout', FPistonLayout);
  AFile.WriteBool(ASection, 'ButtonsAboveManuals', FButtonsAboveManuals);

  FLabels.SaveToFile(AFile, ASection, 'Labels');

  for a := 0 to 4 do
    AFile.WriteInteger(ASection, 'BackgroundImage[' + IntToStr(a) + ']', FBackgroundImages[a]);
  AFile.WriteBool(ASection, 'TrimAboveManuals', FTrimAboveManuals);
  AFile.WriteBool(ASection, 'TrimBelowManuals', FTrimBelowManuals);
  AFile.WriteBool(ASection, 'TrimAboveExtraRows', FTrimAboveExtraRows);

  AFile.WriteBool(ASection, 'DefaultButtonSize', FDefaultButtonSize);
  AFile.WriteInteger(ASection, 'DrawstopWidth', FDrawstopSize.cx);
  AFile.WriteInteger(ASection, 'DrawstopHeight', FDrawstopSize.cy);
  AFile.WriteInteger(ASection, 'PistonWidth', FPistonSize.cx);
  AFile.WriteInteger(ASection, 'PistonHeight', FPistonSize.cy);
  AFile.WriteInteger(ASection, 'PanelWidth', FPanelSize.cx);
  AFile.WriteInteger(ASection, 'PanelHeight', FPanelSize.cy);
end;

procedure TLayout.SetBackgroundImage(const Index, Value: Integer);
begin
  FBackgroundImages[Index] := Value;
end;

procedure TLayout.SetBottomPistonMatrixHeight(const Value: Integer);
begin
  FBottomPistonMatrixHeight := Value;
  Update;
end;

procedure TLayout.SetPairDrawstopCols(const Value: Boolean);
begin
  FPairDrawstopCols := Value;
  Update;
end;

procedure TLayout.SetPistonMatrixWidth(const Value: Integer);
begin
  FPistonMatrixWidth := Value;
  Update;
end;

procedure TLayout.SetSideMatrixHeight(const Value: Integer);
begin
  FSideMatrixSize.cy := Value;
  Update;
end;

procedure TLayout.SetSideMatrixWidth(const Value: Integer);
begin
  FSideMatrixSize.cx := Value;
  Update;
end;

procedure TLayout.SetTopPistonMatrixHeight(const Value: Integer);
begin
  FTopPistonMatrixHeight := Value;
  Update;
end;

procedure TLayout.Update;
var
  a: Integer;
  p: TLabelPosition;
begin
  if FPairDrawstopCols then
    Inc(FSideMatrixSize.cx, FSideMatrixSize.cx mod 2);
  FLeftMatrix.Resize(FSideMatrixSize.cx, FSideMatrixSize.cy);
  FRightMatrix.Resize(FSideMatrixSize.cx, FSideMatrixSize.cy);
  if Assigned(FOwner.FPedalboard) then
    a := 0
  else
    a := 1;
  FPistonMatrix.Resize(FPistonMatrixWidth, FTopPistonMatrixHeight + FOwner.FManuals.Count + (1 - a) * FBottomPistonMatrixHeight);
  a := 2 * FSideMatrixSize.cx - 1;
  if a < 0 then
    a := 0;
  for p := lpTopLeft to lpBottomRight do begin
    while FLabels.FLabels[p].Count > a do
      FLabels.FLabels[p].Delete(FLabels.FLabels[p].Count - 1);
    while FLabels.FLabels[p].Count < a do
      FLabels.FLabels[p].Add('');
  end;
end;

{ TEnclosures }

procedure TEnclosures.Clear;
begin
  inherited;
  FFontColor := - 15;
end;

{ TProjectFile }

constructor TProjectFile.Create(AFilename: string;
  AStoreRelativePaths: Boolean);
begin
  inherited Create(AFilename);
  FStoreRelativePaths := AStoreRelativePaths;
  WriteBool('System', 'RelativePaths', AStoreRelativePaths);
end;

constructor TProjectFile.Create(AFilename: string);
const
  SFOpenErrorEx = 'Cannot open file "%s". %s';
begin
  inherited Create(AFilename);
  if not FileExists(AFilename) then
    raise EFOpenError.CreateFmt(SFOpenErrorEx, [ExpandFileName(FileName), SysErrorMessage(ERROR_FILE_NOT_FOUND)]);
  FStoreRelativePaths := ReadBool('System', 'RelativePaths', False);
end;

function TProjectFile.ReadPath(ASection, AKey,
  ADefaultValue: string): string;
begin
  Result := ReadString(ASection, AKey, ADefaultValue);
  if FStoreRelativePaths then begin
    if Copy(Result, 1, 2) = '.\' then
      Result := ExpandFileName(ExtractFilePath(Filename) + Copy(Result, 3, Length(Result)));
  end;
end;

procedure TProjectFile.WritePath(ASection, AKey, AValue: string);
begin
  if FStoreRelativePaths and (ExtractFileDrive(AValue) = ExtractFileDrive(Filename)) then
    AValue := '.\' + ExtractRelativePath(Filename, AValue);
  WriteString(ASection, AKey, AValue);
end;

initialization
  Initialize;
end.
