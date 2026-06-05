Config = {
    -- [1] Anti-Bypass / Global Secret Variable
    Secret          = "mrPENIS",
 
    -- [2] Scripts & Links
    MainScriptURL   = "https://raw.githubusercontent.com/Krishnasavage/KinaHub/refs/heads/main/Fling.lua",

    -- [3] Social Media
    DiscordURL      = "https://discord.gg/Zw325sCxRM",

    -- [4] File System
    KeyFileName     = "AuroraKey.txt",

    -- [5] GUI Management
    OldGuiName      = "",
    MainGuiName     = "",

    -- [6] Hub Info
    HubName         = "Aurora Hub",
    HubDescription  = "Modern Experience • Maximum Performance",
}

-------------------------------------------------------------------------------
--! LIBRARIES (JSON & CRYPTOGRAPHY) - DO NOT MODIFY
-------------------------------------------------------------------------------
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2};local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\", ['"']='"', ["\b"]="b", ["\f"]="f", ["\n"]="n", ["\r"]="r", ["\t"]="t"};local P={["/"]=  "/"};for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return "\\"  ..(l[T] or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring};e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return #a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at};a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end
local lEncode, lDecode, lDigest = a3, aw, Z

-------------------------------------------------------------------------------
--! CORE FUNCTIONS
-------------------------------------------------------------------------------

local API_URL = "http://127.0.0.1:5000/api"
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local fSetClipboard = setclipboard or toclipboard or function() end
local fGetHwid = gethwid or function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function safeRequest(options)
    local req = request or http_request or syn_request or (http and http.request)
    if not req then return nil, "HTTP not supported" end
    local ok, res = pcall(function() return req(options) end)
    if ok and res then return res else return nil, "Connection Error" end
end

-- Return: (isSuccess, Message, isValidationFail)
local function redeemKey(key)
    local response, err = safeRequest({
        Url = API_URL .. "/keys/redeem",
        Method = "POST",
        Body = lEncode({ key = key, hwid = lDigest(fGetHwid()) }),
        Headers = { ["Content-Type"] = "application/json" },
    })
    
    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.valid then
            if writefile then writefile(Config.KeyFileName, key) end
            return true, "Success", false, false
        end
        
        -- Cek apakah errornya karena HWID?
        local isMismatch = string.find(decoded.message or "", "HWID") ~= nil
        return false, decoded.message or "Key tidak valid", true, isMismatch
    end
    
    return false, err or "Server Error", false, false
end

-------------------------------------------------------------------------------
--! AURORA NOTIFICATION SYSTEM
-------------------------------------------------------------------------------
local function ShowAuroraNotification(title, desc)
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    local NotifGui = Instance.new("ScreenGui", pGui)
    NotifGui.Name = "AuroraNotification"
    
    local NFrame = Instance.new("Frame", NotifGui)
    NFrame.Size = UDim2.new(0, 260, 0, 70)
    NFrame.Position = UDim2.new(1, 20, 1, -90) -- Start off-screen
    NFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
    NFrame.BackgroundTransparency = 0.1
    NFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner", NFrame)
    Corner.CornerRadius = UDim.new(0, 12)
    
    local Stroke = Instance.new("UIStroke", NFrame)
    Stroke.Color = Color3.fromRGB(60, 140, 255)
    Stroke.Thickness = 1.5
    
    -- Animate Stroke Color (Aurora Effect)
    task.spawn(function()
        while NFrame.Parent do
            local hue = 0.5 + math.sin(tick() * 1.2) * 0.2
            Stroke.Color = Color3.fromHSV(hue, 0.9, 1)
            RunService.RenderStepped:Wait()
        end
    end)
    
    local TxtTitle = Instance.new("TextLabel", NFrame)
    TxtTitle.Size = UDim2.new(1, -20, 0, 24)
    TxtTitle.Position = UDim2.new(0, 10, 0, 8)
    TxtTitle.BackgroundTransparency = 1
    TxtTitle.Text = title
    TxtTitle.Font = Enum.Font.GothamBold
    TxtTitle.TextSize = 14
    TxtTitle.TextColor3 = Color3.new(1, 1, 1)
    TxtTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local TxtDesc = Instance.new("TextLabel", NFrame)
    TxtDesc.Size = UDim2.new(1, -20, 0, 20)
    TxtDesc.Position = UDim2.new(0, 10, 0, 32)
    TxtDesc.BackgroundTransparency = 1
    TxtDesc.Text = desc
    TxtDesc.Font = Enum.Font.Gotham
    TxtDesc.TextSize = 12
    TxtDesc.TextColor3 = Color3.fromRGB(180, 185, 200)
    TxtDesc.TextXAlignment = Enum.TextXAlignment.Left

    -- Slide In
    TweenService:Create(NFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -280, 1, -90)
    }):Play()
    
    -- Wait and Slide Out
    task.delay(3.5, function()
        local outTween = TweenService:Create(NFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 1, -90)
        })
        outTween:Play()
        outTween.Completed:Wait()
        NotifGui:Destroy()
    end)
end

-------------------------------------------------------------------------------
--! MAIN SCRIPT
-------------------------------------------------------------------------------

local function StartMainScript()
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    if Config.OldGuiName ~= "" and pGui:FindFirstChild(Config.OldGuiName) then
        pGui[Config.OldGuiName]:Destroy()
        task.wait(0.1)
    end
    _G[Config.Secret] = true
    
    ShowAuroraNotification("✨ Aurora Hub", "Verifikasi Berhasil! Memuat Script...")
    task.wait(1.5)
    loadstring(game:HttpGet(Config.MainScriptURL))()
end

-------------------------------------------------------------------------------
--! GUI
-------------------------------------------------------------------------------

local function CreateGUI()
    local pGui = LocalPlayer:WaitForChild("PlayerGui")

    if pGui:FindFirstChild("AuroraHub") then pGui.AuroraHub:Destroy() end

    local function AnimateAurora(lbl)
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not lbl or not lbl.Parent then conn:Disconnect() return end
            local hue = 0.55 + math.sin(tick() * 1.5) * 0.2
            lbl.TextColor3 = Color3.fromHSV(hue, 0.85, 1)
        end)
    end

    local function MakeCorner(parent, radius)
        local c = Instance.new("UICorner", parent)
        c.CornerRadius = UDim.new(0, radius or 10)
        return c
    end
    local function MakeStroke(parent, color, thick)
        local s = Instance.new("UIStroke", parent)
        s.Color = color or Color3.fromRGB(50, 55, 70)
        s.Thickness = thick or 1.5
        return s
    end
    local function AnimBtn(btn, norm, hover)
        local sc = Instance.new("UIScale", btn)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=hover}):Play()
            TweenService:Create(sc,  TweenInfo.new(0.2), {Scale=1.03}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=norm}):Play()
            TweenService:Create(sc,  TweenInfo.new(0.2), {Scale=1}):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(sc, TweenInfo.new(0.1), {Scale=0.96}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(sc, TweenInfo.new(0.1), {Scale=1.03}):Play()
        end)
    end

    ---------- ScreenGui ----------
    local SG = Instance.new("ScreenGui")
    SG.Name = "AuroraHub"
    SG.ResetOnSpawn = false
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SG.Parent = pGui

    ---------- Main frame ----------
    local W, H = 420, 290
    local F = Instance.new("Frame", SG)
    F.Size     = UDim2.new(0, 0, 0, 0)
    F.Position = UDim2.new(0.5, 0, 0.5, 0)
    F.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    F.BackgroundTransparency = 0.05
    F.Active   = true
    F.Draggable = true
    F.ClipsDescendants = true
    MakeCorner(F, 16)
    MakeStroke(F, Color3.fromRGB(45, 90, 200), 2)

    TweenService:Create(F, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, W, 0, H),
        Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
    }):Play()

    ---------- Glow Effect ----------
    local Glow = Instance.new("ImageLabel", F)
    Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
    Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857472"
    Glow.ImageColor3 = Color3.fromRGB(60, 120, 255)
    Glow.ImageTransparency = 0.85
    Glow.ZIndex = 0

    ---------- Title ----------
    local Title = Instance.new("TextLabel", F)
    Title.Size = UDim2.new(1, -60, 0, 32)
    Title.Position = UDim2.new(0, 20, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = Config.HubName
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    AnimateAurora(Title)

    local Sub = Instance.new("TextLabel", F)
    Sub.Size = UDim2.new(1, -20, 0, 16)
    Sub.Position = UDim2.new(0, 20, 0, 48)
    Sub.BackgroundTransparency = 1
    Sub.Text = Config.HubDescription
    Sub.Font = Enum.Font.GothamMedium
    Sub.TextSize = 12
    Sub.TextColor3 = Color3.fromRGB(130, 135, 150)
    Sub.TextXAlignment = Enum.TextXAlignment.Left

    ---------- Close button ----------
    local CloseBtn = Instance.new("TextButton", F)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 16)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    CloseBtn.AutoButtonColor = false
    MakeCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

    ---------- Key input ----------
    local InputBox = Instance.new("TextBox", F)
    InputBox.Size = UDim2.new(1, -40, 0, 48)
    InputBox.Position = UDim2.new(0, 20, 0, 90)
    InputBox.PlaceholderText = "Paste key dari Discord di sini..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(90, 95, 115)
    InputBox.Text = ""
    InputBox.Font = Enum.Font.GothamMedium
    InputBox.TextSize = 14
    InputBox.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    InputBox.TextColor3 = Color3.fromRGB(230, 235, 255)
    InputBox.ClearTextOnFocus = false
    InputBox.TextEditable = true
    MakeCorner(InputBox, 8)
    local InStroke = MakeStroke(InputBox, Color3.fromRGB(45, 50, 70), 1.5)
    local pad = Instance.new("UIPadding", InputBox)
    pad.PaddingLeft = UDim.new(0, 14)

    InputBox.Focused:Connect(function()
        TweenService:Create(InStroke, TweenInfo.new(0.3), {Color=Color3.fromRGB(70, 130, 255)}):Play()
    end)
    InputBox.FocusLost:Connect(function()
        TweenService:Create(InStroke, TweenInfo.new(0.3), {Color=Color3.fromRGB(45, 50, 70)}):Play()
    end)

    ---------- Buttons row ----------
    local function MakeBtn(parent, text, x, w, bg)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, w, 0, 44)
        btn.Position = UDim2.new(0, x, 0, 154)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = bg
        btn.AutoButtonColor = false
        MakeCorner(btn, 8)
        return btn
    end

    local padX = 20
    local gap = 10
    local bw = (W - padX*2 - gap) / 2

    local VerifyBtn = MakeBtn(F, "✓  VERIFY KEY", padX, bw, Color3.fromRGB(45, 95, 225))
    AnimBtn(VerifyBtn, Color3.fromRGB(45, 95, 225), Color3.fromRGB(60, 120, 255))

    local CopyBtn = MakeBtn(F, "🔑  GET KEY", padX + bw + gap, bw, Color3.fromRGB(30, 34, 48))
    MakeStroke(CopyBtn, Color3.fromRGB(60, 65, 85), 1.5)
    AnimBtn(CopyBtn, Color3.fromRGB(30, 34, 48), Color3.fromRGB(45, 50, 70))

    ---------- Status ----------
    local Status = Instance.new("TextLabel", F)
    Status.Size = UDim2.new(1, -40, 0, 22)
    Status.Position = UDim2.new(0, 20, 0, 214)
    Status.BackgroundTransparency = 1
    Status.Text = "Menunggu Input Key..."
    Status.Font = Enum.Font.GothamMedium
    Status.TextSize = 12
    Status.TextColor3 = Color3.fromRGB(120, 125, 140)
    Status.TextXAlignment = Enum.TextXAlignment.Center

    ---------- Footer ----------
    local Footer = Instance.new("TextLabel", F)
    Footer.Size = UDim2.new(1, 0, 0, 16)
    Footer.Position = UDim2.new(0, 0, 1, -22)
    Footer.BackgroundTransparency = 1
    Footer.Text = "Discord: https://discord.gg/Zw325sCxRM"
    Footer.Font = Enum.Font.Gotham
    Footer.TextSize = 11
    Footer.TextColor3 = Color3.fromRGB(90, 95, 110)
    Footer.TextXAlignment = Enum.TextXAlignment.Center

    ---------- Logic ----------
    local verifiedKey = ""

    local function setStatus(msg, color)
        Status.Text = msg
        Status.TextColor3 = color
    end

    CopyBtn.MouseButton1Click:Connect(function()
        fSetClipboard(Config.DiscordURL)
        setStatus("✓ Link Discord berhasil di-copy!", Color3.fromRGB(100, 220, 140))
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        local key = InputBox.Text:match("^%s*(.-)%s*$")
        if key == "" then
            setStatus("Harap masukkan key terlebih dahulu.", Color3.fromRGB(255, 100, 100))
            return
        end
        setStatus("⏳ Memverifikasi...", Color3.fromRGB(255, 200, 80))
        VerifyBtn.Text = "MEMVERIFIKASI..."

                task.spawn(function()
            local ok, msg, isValidationFail, isHwidMismatch = redeemKey(key)
            if ok then
                verifiedKey = key
                setStatus("✓ Verifikasi Sukses!", Color3.fromRGB(100, 220, 140))
                
                TweenService:Create(F, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                }):Play()
                
                task.wait(0.4)
                SG:Destroy()
                StartMainScript()
            else
                VerifyBtn.Text = "✓  VERIFY KEY"
                
                -- KICK HANYA JIKA HWID MISMATCH
                if isHwidMismatch then
                    LocalPlayer:Kick("[ ❄️ Aurora Hub ❄️ ]\nSecurity Alert: HWID Mismatch!\nKey ini sudah terkunci di perangkat lain.\nSilakan gunakan /resethwid di Discord.")
                else
                    -- WARNING BIASA (JIKA KEY SALAH)
                    setStatus("⚠️ " .. msg, Color3.fromRGB(255, 170, 0))
                    ShowAuroraNotification("⚠️ Warning", msg)
                end
            end
        end)

    end)

       ---------- Auto-login ----------
    if isfile and isfile(Config.KeyFileName) then
        local saved = readfile(Config.KeyFileName)
        if saved and saved ~= "" then
            saved = saved:match("^%s*(.-)%s*$")
            InputBox.Text = saved
            setStatus("⏳ Auto-login diproses...", Color3.fromRGB(100, 160, 255))
            
            task.spawn(function()
                local ok, msg, isValidationFail, isHwidMismatch = redeemKey(saved)
                if ok then
                    verifiedKey = saved
                    setStatus("✓ Auto-login berhasil!", Color3.fromRGB(100, 220, 140))
                    
                    TweenService:Create(F, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                    }):Play()
                    
                    task.wait(0.4)
                    SG:Destroy()
                    StartMainScript()
                else
                    -- Cek apakah KICK atau cuma WARNING
                    if isHwidMismatch then
                        LocalPlayer:Kick("[ ❄️ Aurora Hub ❄️ ]\n\nAuto-Login Gagal: HWID Mismatch!\nKey ini terdeteksi dipakai di device lain.\nSilakan gunakan /resethwid di Discord.")
                    else
                        setStatus("⚠️ " .. msg, Color3.fromRGB(255, 170, 0))
                        ShowAuroraNotification("⚠️ Auto-login Gagal", msg)
                    end
                end  
            end)
        end
    end

end

-------------------------------------------------------------------------------
--! INIT
-------------------------------------------------------------------------------
if Config.MainGuiName ~= "" and LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(Config.MainGuiName) then
    StartMainScript()
    return
end

CreateGUI()
