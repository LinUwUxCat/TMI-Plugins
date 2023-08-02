class Trigger{
    vec3 position;
    vec3 size;
    string name;
    Trigger(vec3 p, vec3 s, string n){
        position = p;
        size = s;
        name = n;
    }
    Trigger(){
        position = vec3(1,1,1);
        size = vec3(1,1,1);
        name = "Trigger";
    }
    vec3 endPos(){
        return position+size;
    }
};
array<Trigger> triggers = {};
bool open = true;
uint c = 0;
bool justOpened;
string newName = "\n";
void OnRunStep(SimulationManager@ simManager){

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
    UI::Begin("Trigger Manager");
    UI::BeginTabBar("Tabs");
    CommandList l;
    int deleted = -1;
    bool hasEdits = false;
    if (justOpened){
        if (UI::BeginTabItem("Welcome!")){
            UI::Text("Please add a trigger to start.");
            UI::EndTabItem();
        }
    }
    for(uint i = 0; i<triggers.Length; i++){
        if (UI::BeginTabItem(triggers[i].name+"##"+i)){
            UI::DragFloat3("Pos", triggers[i].position, 5.0f);
            UI::DragFloat3("Size", triggers[i].size, 50.0f);
            newName = UI::InputText("Name", (newName=="\n"||newName==triggers[i].name)?triggers[i].name:newName);
            if (UI::Button("Apply")){
                triggers[i].name = newName;
                newName = "\n";
            }
            UI::SameLine();
            if (UI::Button("Delete")){
                hasEdits = true;
                deleted = i;
            }
            UI::EndTabItem();
        }
        auto toAdd = triggers[i];
        l.Content += "add_trigger " + toAdd.position.x + " " + toAdd.position.y + " " + toAdd.position.z + " " + (toAdd.position.x + toAdd.size.x) + " " + (toAdd.position.y + toAdd.size.y) + " " + (toAdd.position.z + toAdd.size.z) + "\n";
    }
    if (triggers.Length > 0) hasEdits = true;
    if (hasEdits){
        l.Content = "remove_trigger all\n" + l.Content;
        if (deleted != -1){
            triggers.RemoveAt(deleted);
            l.Content += "remove_trigger "+(deleted+1);
        }
        log(l.Content);
        l.Process(CommandListProcessOption::ExecuteImmediately);
    }
    if (UI::BeginTabItem("+##"+c)){
        c++;
        justOpened=false;
        auto toAdd = Trigger(vec3(512 + triggers.Length,64,512), vec3(10,10,10), "Trigger " + c);
        triggers.Add(toAdd);
        ExecuteCommand("add_trigger " + toAdd.position.x + " " + toAdd.position.y + " " + toAdd.position.z + " " + (toAdd.position.x + toAdd.size.x) + " " + (toAdd.position.y + toAdd.size.y) + " " + (toAdd.position.z + toAdd.size.z));
        UI::EndTabItem();
    }
    if (deleted==0)justOpened = true;
    UI::EndTabBar();
    UI::End();
    
}
void Main(){
    justOpened = true;
}
void OnDisabled(){
}
PluginInfo@ GetPluginInfo(){
    auto info = PluginInfo();
    info.Name = "Trigger Manager";
    info.Author = "LinuxCat";
    info.Version = "v1.0.0";
    info.Description = "A simple trigger manager";
    return info;
}