// Documentation available at https://donadigo.com/<DOCS LINK>
/**************/
/*****VARS*****/
/**************/
bool showPosition = true;
bool showRotation = true;
bool showSpeed = true;
bool showVelocity = true;
bool showStuntScore = true;
bool showRaceTime = true;
bool showGear = true;
bool showRPM = true;
bool showCPs = true;
int raceTime = 0;
uint speed = 0;
string position = "";
string rotation = "";
string velocity = "";
uint stuntScore = 0;
int gear = 0;
float rpm = 0.0;
string CPs = "";

bool showSettingsButton = true;
bool showSettings = false;
bool settingsOpen = false;

void OnRunStep(SimulationManager@ simManager){   
    auto playerInfo = simManager.get_PlayerInfo();
    auto car = simManager.get_SceneVehicleCar();
    auto dyna = simManager.get_Dyna();
    auto state = dyna.CurrentState;
    
    
    auto carPos = state.Location.Position;
    auto carRot = state.Location.Rotation;
    float yaw;float pitch;float roll;
    carRot.GetYawPitchRoll(yaw,pitch,roll);
    position = Text::FormatFloat(carPos.x, "", 0, 3) + ", " + Text::FormatFloat(carPos.y, "", 0, 3) + ", " + Text::FormatFloat(carPos.z, "", 0, 3);
    rotation = Text::FormatFloat(yaw, "", 0, 3) + ", " + Text::FormatFloat(pitch, "", 0, 3) + ", " + Text::FormatFloat(roll, "", 0, 3);
    
    
    speed = playerInfo.DisplaySpeed;
    
    auto vel = car.CurrentLocalSpeed;
    velocity = Text::FormatFloat(state.LinearSpeed.x, "", 0, 3) + ", " + Text::FormatFloat(state.LinearSpeed.y, "", 0, 3) + ", " + Text::FormatFloat(state.LinearSpeed.z, "", 0, 3);
	
	raceTime = playerInfo.RaceTime;
	
	stuntScore = playerInfo.StuntsScore;
	
	gear = car.CarEngine.Gear - car.CarEngine.RearGear;
	
	rpm = car.CarEngine.ActualRPM;
	
	CPs = playerInfo.CurCheckpointCount + "/" + playerInfo.Checkpoints.get_Length();
}

void OnSimulationBegin(SimulationManager@ simManager){
}

void OnSimulationStep(SimulationManager@ simManager, bool userCancelled){
    
}

void OnSimulationEnd(SimulationManager@ simManager, SimulationResult result){
}

void OnCheckpointCountChanged(SimulationManager@ simManager, int count, int target){

}

void OnLapsCountChanged(SimulationManager@ simManager, int count, int target){
}

void Render(){
    UI::Begin("LinuxCat's Properties");
    if (showPosition) UI::Text("Position : " + position);
    if (showVelocity) UI::Text("Velocity : " + velocity);
    if (showRotation) UI::Text("YawPitchRoll : " + rotation);
    if (showGear) UI::Text("Gear : " + gear);
    if (showRPM) UI::Text("RPM : " + rpm);
    if (showSpeed) UI::Text("Displayed Speed : " + speed);
    if (showRaceTime) UI::Text("Race Time : " + raceTime);
    if (showStuntScore) UI::Text("Stunt Score : " + stuntScore);
    if (showCPs) UI::Text("Checkpoint " + CPs);
    if (showSettingsButton)if (UI::Button("Settings")){
        showSettings = true;
    }
    UI::End();
    if (showSettings){
        settingsOpen = true;
        UI::Begin("LinuxCat's Properties settings", showSettings);
        showPosition = UI::Checkbox("Show Position", showPosition); UI::SameLine();
        showVelocity = UI::Checkbox("Show Velocity", showVelocity); 
        showRotation = UI::Checkbox("Show Rotation", showRotation); UI::SameLine();
        showGear = UI::Checkbox("Show Gear", showGear);
        showRPM = UI::Checkbox("Show RPM", showRPM); UI::SameLine();
        showSpeed = UI::Checkbox("Show Speed", showSpeed);
        showRaceTime = UI::Checkbox("Show Race Time", showRaceTime); UI::SameLine();
        showStuntScore = UI::Checkbox("Show Stunt Score", showStuntScore);
        showCPs = UI::Checkbox("Show Checkpoints", showCPs); UI::SameLine();
        showSettingsButton = UI::Checkbox("Show Settings button", showSettingsButton);
        if (!showSettingsButton){
            UI::Text("You can open the window again with\nthe linuxcat_properties_settings command");
        }
        UI::End();
    } else {
        if (settingsOpen){
            SetVariable("linuxcat_properties_show_position", showPosition);
            SetVariable("linuxcat_properties_show_rotation", showRotation);
            SetVariable("linuxcat_properties_show_speed", showSpeed);
            SetVariable("linuxcat_properties_show_velocity", showVelocity);
            SetVariable("linuxcat_properties_show_stuntscore", showStuntScore);
            SetVariable("linuxcat_properties_show_racetime", showRaceTime);
            SetVariable("linuxcat_properties_show_gear", showGear);
            SetVariable("linuxcat_properties_show_rpm", showRPM);
            SetVariable("linuxcat_properties_show_checkpointcount", showCPs);
            SetVariable("linuxcat_properties_show_settingsbutton", showSettingsButton);
            settingsOpen = false;
        }
    }


}

void Main(){
    RegisterCustomCommand("linuxcat_properties_settings", "Shows LinuxCat's properties settings", forceShowSettings);
    RegisterVariable("linuxcat_properties_show_position", true);
    RegisterVariable("linuxcat_properties_show_rotation", true);
    RegisterVariable("linuxcat_properties_show_speed", true);
    RegisterVariable("linuxcat_properties_show_velocity", true);
    RegisterVariable("linuxcat_properties_show_stuntscore", true);
    RegisterVariable("linuxcat_properties_show_racetime", true);
    RegisterVariable("linuxcat_properties_show_gear", true);
    RegisterVariable("linuxcat_properties_show_rpm", true);
    RegisterVariable("linuxcat_properties_show_checkpointcount", true);
    RegisterVariable("linuxcat_properties_show_settingsbutton", true);
    GetVariable("linuxcat_properties_show_position", showPosition);
    GetVariable("linuxcat_properties_show_rotation", showRotation);
    GetVariable("linuxcat_properties_show_speed", showSpeed);
    GetVariable("linuxcat_properties_show_velocity", showVelocity);
    GetVariable("linuxcat_properties_show_stuntscore", showStuntScore);
    GetVariable("linuxcat_properties_show_racetime", showRaceTime);
    GetVariable("linuxcat_properties_show_gear", showGear);
    GetVariable("linuxcat_properties_show_rpm", showRPM);
    GetVariable("linuxcat_properties_show_checkpointcount", showCPs);
    GetVariable("linuxcat_properties_show_settingsbutton", showSettingsButton);
}

void OnDisabled(){
    SetVariable("linuxcat_properties_show_position", showPosition);
    SetVariable("linuxcat_properties_show_rotation", showRotation);
    SetVariable("linuxcat_properties_show_speed", showSpeed);
    SetVariable("linuxcat_properties_show_velocity", showVelocity);
    SetVariable("linuxcat_properties_show_stuntscore", showStuntScore);
    SetVariable("linuxcat_properties_show_racetime", showRaceTime);
    SetVariable("linuxcat_properties_show_gear", showGear);
    SetVariable("linuxcat_properties_show_rpm", showRPM);
    SetVariable("linuxcat_properties_show_checkpointcount", showCPs);
    SetVariable("linuxcat_properties_show_settingsbutton", showSettingsButton);
}

PluginInfo@ GetPluginInfo(){
    auto info = PluginInfo();
    info.Name = "Properties Window";
    info.Author = "LinuxCat";
    info.Version = "v1.1.0";
    info.Description = "An alternative customizable properties window";
    return info;
}
void forceShowSettings(int fromTime, int toTime, const string&in command, const array<string>&in args){
    showSettings = true;
}
