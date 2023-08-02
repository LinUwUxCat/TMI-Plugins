float degToRad(float deg){
    return Math::PI / 180 * deg;
}
float EuclideanNorm(vec3 vector){
    return Math::Sqrt(Math::Pow(vector.x,2) + Math::Pow(vector.y,2) + Math::Pow(vector.z,2));
}

class Trigger{
    vec3 position;
    vec3 size;
    vec3 rotation;
    Trigger(vec3 p, vec3 s, vec3 r){
        position = p;
        size = s;
        rotation = r;
    }
    Trigger(){
        position = vec3(1,1,1);
        size = vec3(1,1,1);
        rotation = vec3(1,1,1);
    }
    /**
     * Returns an array of points corresponding to the points of the trigger.
     * You end up with an array of 8 points, with:
     * 0 : origin [D]
     * 1 : origin + x size [A]
     * 2 : origin + x and y size [E]
     * 3 : origin + x and z size [B]
     * 4 : opposite to the origin [F]
     * 5 : origin + y size [H]
     * 6 : origin + y and z size [G]
     * 7 : origin + z size [C]
     * [X] is the point you can find on this graph : https://i.stack.imgur.com/hYcv0.png
     * if confused, remember TM has Y-up and not Z-up like blender or other software
     * */
    array<vec3> points(){
        array<vec3> v = {};
        v.Add(vec3(0,0,0));
        v.Add(vec3(0+size.x, 0, 0));
        v.Add(vec3(0+size.x, 0+size.y, 0));
        v.Add(vec3(0+size.x, 0, 0+size.z));
        v.Add(vec3(0+size.x, 0+size.y, 0+size.z));
        v.Add(vec3(0, 0+size.y, 0));
        v.Add(vec3(0, 0+size.y, 0+size.z));
        v.Add(vec3(0, 0, 0+size.z));

        //X
        auto sinXrot = Math::Sin(degToRad(rotation.x));
        auto cosXrot = Math::Cos(degToRad(rotation.x));
        for (int i = 0; i<v.Length; i++){
            auto p = v[i];
            auto z = p.z;
            auto y = p.y;
            v[i] = vec3(
            p.x,
            y*cosXrot - z*sinXrot, 
            z*cosXrot + y*sinXrot);
        }
        //Y
        auto sinYrot = Math::Sin(degToRad(rotation.y));
        auto cosYrot = Math::Cos(degToRad(rotation.y));
        for (int i = 0; i<v.Length; i++){
            auto p = v[i];
            auto x = p.x;
            auto z = p.z;
            v[i] = vec3(
            x *cosYrot - z*sinYrot,
            p.y,
            z*cosYrot + x*sinYrot);
        }
        //Z
        auto sinZrot = Math::Sin(degToRad(rotation.z));
        auto cosZrot = Math::Cos(degToRad(rotation.z));
        for (int i = 0; i<v.Length; i++){
            auto p = v[i];
            auto x = p.x;
            auto y = p.y;
            v[i] = vec3(
            + x*cosZrot - y*sinZrot,
            y*cosZrot + x*sinZrot,
            p.z);
        }
        //Apply position back
        for(int i = 0; i<v.Length; i++){
            v[i]+=position;
        }
        return v;
    }
    /**
     * Checks if a point is inside the trigger or not
     */
    bool isInside(vec3 point){
        auto v = points();

        auto XLength = Math::Distance(v[1], v[0]);
        auto YLength = Math::Distance(v[7], v[0]);
        auto ZLength = Math::Distance(v[5], v[0]);
        auto XLocal = (v[1] - v[0])/XLength;
        auto YLocal = (v[7] - v[0])/YLength;
        auto ZLocal = (v[5] - v[0])/ZLength;
        auto I = (v[0]+v[4])/2;
        auto V = point - I;
        auto px = Math::Abs(Math::Dot(V, XLocal));
        auto py = Math::Abs(Math::Dot(V, YLocal));
        auto pz = Math::Abs(Math::Dot(V, ZLocal));
        if ( (2*px > XLength) || (2*py > YLength) || (2*pz > ZLength) ){
            return false;
        } else return true;

    }

};
array<Trigger> triggers = {};
bool open = true;
uint c = 0;
bool justOpened;
bool debugMode = true;
vec3 carPos = vec3(0,0,0);
void OnRunStep(SimulationManager@ simManager){
    auto dyna = simManager.get_Dyna();
    auto state = dyna.CurrentState;
    carPos = state.Location.Position;
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
    if (justOpened){
        if (UI::BeginTabItem("Welcome!")){
            UI::Text("Please add a trigger to start.");
            UI::EndTabItem();
        }
    }
    for(uint i = 0; i<triggers.Length; i++){
        if (UI::BeginTabItem("Trigger " + (i+1))){
            triggers[i].position.x = UI::SliderFloat("PosX", triggers[i].position.x, 0,600);
            triggers[i].position.y = UI::SliderFloat("PosY", triggers[i].position.y, 0,600);
            triggers[i].position.z = UI::SliderFloat("PosZ", triggers[i].position.z, 0,600);
            triggers[i].rotation.x = UI::SliderFloat("RotX", triggers[i].rotation.x, 0,360);
            triggers[i].rotation.y = UI::SliderFloat("RotY", triggers[i].rotation.y, 0,360);
            triggers[i].rotation.z = UI::SliderFloat("RotZ", triggers[i].rotation.z, 0,360);
            triggers[i].size.x = UI::SliderFloat("SizeX", triggers[i].size.x,0.001,20);
            triggers[i].size.y = UI::SliderFloat("SizeY", triggers[i].size.y,0.001,20);
            triggers[i].size.z = UI::SliderFloat("SizeZ", triggers[i].size.z,0.001,20);

            UI::Text("" + triggers[i].isInside(carPos));
            if (UI::Button("Delete")){
                deleted = i;
            }
            UI::EndTabItem();
        }
        auto toAdd = triggers[i];
        if (debugMode) {
            auto v = triggers[i].points();
            for(int j = 0; j<v.Length; j++){
                l.Content += "add_trigger " + v[j].x + " " + v[j].y + " " + v[j].z + " " + (v[j].x+0.5) + " " + (v[j].y+0.5) + " " + (v[j].z+0.5)+ "\n";
            }
        }
    }
    if (deleted != -1){
        triggers.RemoveAt(deleted);
    }
    if (debugMode){
        l.Content = "remove_trigger all\n" + l.Content;
        l.Content += "add_trigger " + carPos.x + " " + carPos.y + " " + carPos.z + " " + (carPos.x + 0.1) + " " + (carPos.y + 0.1) + " " + (carPos.z + 0.1) + "\n";
        l.Process(CommandListProcessOption::ExecuteImmediately);
    }
    if (UI::BeginTabItem("+##"+c)){
        c++;
        justOpened=false;
        auto toAdd = Trigger(vec3(378 + triggers.Length,23,564), vec3(10,10,10), vec3(0,0,0));
        triggers.Add(toAdd);
        UI::EndTabItem();
    }
    if (deleted==0)justOpened = true;
    debugMode = UI::Checkbox("Debug Mode", debugMode);
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
    info.Name = "Custom Triggers";
    info.Author = "LinuxCat";
    info.Version = "v1.0.0";
    info.Description = "Manage custom triggers";
    return info;
}