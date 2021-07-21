-- official ui source.
-- made by a_003.

local module = {};
local input = {};
local drag = {};
local config = {};
local realcfg = {};

-- services

local uis = game:GetService("UserInputService");
local inputbegan = uis.InputBegan;
local inputended = uis.InputEnded;
local connect = inputbegan.Connect;

local run = game:GetService("RunService");
local step = run.RenderStepped;

local http = game:GetService("HttpService");
local jsonencode = http.JSONEncode;
local jsondecode = http.JSONDecode;

local tween = game:GetService("TweenService");

local mouse = game:GetService("Players").LocalPlayer:GetMouse();

local newinst = Instance.new;
local udim2 = UDim2.new;
local v2 = Vector2.new;
local rect = Rect.new;
local color = Color3.new;
local colorsequence = ColorSequence.new;
local keypoint = ColorSequenceKeypoint.new;
local tweeninfo = TweenInfo.new;

-- input

do
	local keyboard = Enum.UserInputType.Keyboard;
	local mouse1 = Enum.UserInputType.MouseButton1;
	local mouse2 = Enum.UserInputType.MouseButton2;

	input.keyboard = {};
	input.mouse1 = uis:IsMouseButtonPressed(mouse1);
	input.mouse2 = uis:IsMouseButtonPressed(mouse2);

	connect(inputbegan, function(inputobject, typingormoving)
		if not typingormoving then
			if inputobject.UserInputType == keyboard then
				input.keyboard[inputobject.KeyCode] = true;

				if inputobject.KeyCode == Enum.KeyCode.P and module.toggleui then
					module.toggleui();
				end
			end
		end

		if inputobject.UserInputType == mouse1 then
			input.mouse1 = true;
		elseif inputobject.UserInputType == mouse2 then
			input.mouse2 = true;
		end

		return;
	end)

	connect(inputended, function(inputobject)
		if inputobject.UserInputType == keyboard then
			input.keyboard[inputobject.KeyCode] = false;
		elseif inputobject.UserInputType == mouse1 then
			input.mouse1 = false;
		elseif inputobject.UserInputType == mouse2 then
			input.mouse2 = false;
		end

		return;
	end)
end

-- ui

do
	-- colors

	local darkergrey = color(0.082352941176471, 0.082352941176471, 0.098039215686275); -- (21, 21, 25)
	local darkgrey = color(0.14509803921569, 0.14901960784314, 0.17254901960784); -- (37, 38, 43)
	local grey = color(0.2078431372549, 0.21176470588235, 0.24705882352941); -- (53, 54, 63)
	local lowlightgrey = color(0.32156862745098, 0.32549019607843, 0.38039215686275); -- (82, 83, 97)
	local lightgrey = color(0.83529411764706, 0.83529411764706, 0.83529411764706); -- (213, 213, 213)
	local white = color(1, 1, 1); -- (255, 255, 255)

	local blue = color(0.3843137254902, 0.49803921568627, 1); -- (98, 127, 255)
	local darkblue = color(0.25098039215686, 0.33725490196078, 0.65882352941176); -- (64, 86, 168)

	-- fonts

	local gotham = Enum.Font.Gotham;
	local gothambold = Enum.Font.GothamBold;
	local gothamblack = Enum.Font.GothamBlack;

	local left = Enum.TextXAlignment.Left;

	-- main

	module.contents = {};

	function module:loadconfig(name)
		local data = readfile(name, 6);

		if data and pcall(jsondecode, http, data) then
			local decoded = jsondecode(http, data);
			local newconfig = {};
			local colortable = {};

			for name, val in pairs(decoded) do
				if typeof(val) == "table" then
					if val[1] and val[2] and val[3] then
						colortable[name] = color(val[1], val[2], val[3]);
					end
				else
					if module.contents[name] and module.contents[name].setvalue then
						module.contents[name]:setvalue(val);
					end
				end
			end

			if module.contents.colorpickers then
				module.contents.colorpickers:refresh(colortable);
			end
		end

		return;
	end

	function module:saveconfig(name)
		local newconfig = {};

		for name, val in pairs(config) do
			if typeof(val) == "Color3" then
				newconfig[name] = {val.r, val.g, val.b};
			else
				newconfig[name] = val;
			end
		end

		return writefile(name, jsonencode(http, newconfig), 6);
	end

	function module:create(class, properties)
		local inst = newinst(class);

		for n, v in pairs(properties) do
			inst[n] = v;
		end

		return inst;
	end

	function module:tween(obj, t, properties)
		tween:Create(obj, tweeninfo(t), properties):Play();
	end

	module.templates = {
		roundlabel = module:create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=4820210696",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect(25, 25, 25, 25)
		}),
		roundbutton = module:create("ImageButton", {
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=4820210696",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect(25, 25, 25, 25)
		})
	};

	function module:window(title, name)
		local window = {};

		-- physical window

		window.ui = module:create("ScreenGui", {
			Name = string.rep("\n", math.random(1, 10)),
			Parent = game:GetService("CoreGui");
		});

		local main = module.templates.roundbutton:Clone();
		main.Position = udim2(0, 300, 0, 300);
		main.Size = udim2(0, 847, 0, 462);
		main.ImageColor3 = darkgrey;
		main.SliceScale = 0.2;
		main.Parent = window.ui;
		window.main = main;

		function module.toggleui()
			window.main.Visible = not window.main.Visible;
		end

		local categoryholder = module.templates.roundlabel:Clone();
		categoryholder.Position = udim2(0, 5, 0, 25);
		categoryholder.Size = udim2(0, 135, 1, -30);
		categoryholder.ImageColor3 = grey;
		categoryholder.SliceScale = 0.2;
		categoryholder.Parent = main;

		-- position

		connect(main.MouseButton1Down, function()
			coroutine.wrap(function()
				local mouseposition = v2(mouse.X, mouse.Y);
				local mouseoffset = mouseposition - main.AbsolutePosition;

				repeat
					mouseposition = v2(mouse.X, mouse.Y);
					local rel = mouseposition - mouseoffset;

					if input.mouse1 then
						main.Position = udim2(0, rel.X, 0, rel.Y);
					end

					step:Wait();
				until
					not input.mouse1;
			end)();
		end);

		-- Size

		local resizer = module:create("TextButton", {
			BackgroundTransparency = 1,
			Position = udim2(1, -10, 1, -10);
			Size = udim2(0, 15, 0, 15);
			Text = "",
			Parent = window.main;
		});

		connect(resizer.MouseButton1Down, function()
			coroutine.wrap(function()
				local mouseposition = v2(mouse.X, mouse.Y);
				local offset = main.AbsoluteSize + main.AbsolutePosition - mouseposition;

				repeat
					local mouseposition = v2(mouse.X, mouse.Y);
					local mouseoffset = mouseposition - main.AbsolutePosition + offset;

					local x, y = math.clamp(mouseoffset.X, 774, 1400), math.clamp(mouseoffset.Y, 413, 800);

					window.main.Size = udim2(0, x, 0, y);

					step:Wait();
				until
					not input.mouse1;
			end)();
		end)

		-- title

		local titleimage = module.templates.roundlabel:Clone();
		titleimage.Size = udim2(1, 0, 0, 20);
		titleimage.ImageColor3 = darkergrey;
		titleimage.SliceScale = 0.2;
		titleimage.Parent = window.main;

		local cutframe = module:create("Frame", {
			BackgroundColor3 = darkergrey,
			BorderSizePixel = 0,
			Position = udim2(0, 0, 1, -5),
			Size = udim2(1, 0, 0, 5),
			Parent = titleimage
		});

		local titletext = module:create("TextLabel", {
			BackgroundTransparency = 1,
			Position = udim2(0, 10, 0, 0),
			Size = udim2(1, -3, 1, 0),
			Font = gothambold,
			Text = title,
			TextColor3 = white,
			TextSize = 12,
			TextXAlignment = left,
			Parent = titleimage
		});

		local titlecolor = module:create("UIGradient", {
			Color = colorsequence({
				keypoint(0, color(0.384314, 0.498039, 1)),
				keypoint(0.520799, color(0.933412, 0.218244, 0.283025)),
				keypoint(1, color(1, 0.184314, 0.196078))
			}),
			Parent = titletext
		});

		-- categories & cheats

		window.categories = {};
		window.categorycount = 0;
		window.curcategory = "";

		function window:category(name)
			local category = {};

			local button = module.templates.roundbutton:Clone();
			button.Position = udim2(0, 5, 0, 5 + window.categorycount * 40 + 5 * window.categorycount);
			button.Size = udim2(0, 125, 0, 40);
			button.ImageColor3 = darkgrey;
			button.SliceScale = 0.2;
			button.Parent = categoryholder;
			category.button = button;

			local buttontext = module:create("TextLabel", {
				BackgroundTransparency = 1,
				Size = udim2(1, 0, 1, 0),
				Font = gothamblack,
				Text = name,
				TextColor3 = lightgrey,
				TextSize = 14,
				Parent = category.button
			});
			category.buttonlabel = buttontext;

			-- main

			local main = module.templates.roundlabel:Clone();
			main.Position = udim2(0, 150, 0, 25);
			main.Size = udim2(1, -155, 1, -30);
			main.ImageColor3 = grey;
			main.SliceScale = 0.2;
			main.Visible = false;
			main.Parent = window.main;
			category.main = main;

			local s1 = module.templates.roundlabel:Clone();
			s1.Position = udim2(0, 5, 0, 5);
			s1.Size = udim2(0.5, -10, 1, -10);
			s1.ImageColor3 = darkgrey;
			s1.SliceScale = 0.2;
			s1.Parent = category.main;

			local container = module:create("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = udim2(1, 0, 1, 0),
				CanvasSize = udim2(0, 0, 0, 0),
				ScrollBarImageColor3 = lightgrey,
				ScrollBarThickness = 1,
				Parent = s1
			});

			category.section1 = container;

			local s2 = s1:Clone();
			s2.Position = udim2(0.5, 5, 0, 5);
			s2.Parent = category.main;

			local container = s2:WaitForChild("ScrollingFrame");

			category.section2 = container;

			-- cheats

			local offsets = {0, 0}; -- x, y
			local last = {"", ""};

			function category:new(type, section, name, additionalproperties, callback)
				local offset = offsets[section];
				local parent = category[section == 1 and "section1" or "section2"];

				local additionalproperties = additionalproperties or {};
				local min = additionalproperties.min or 0;
				local max = additionalproperties.max or 100;
				local default = additionalproperties.default;
				local index = additionalproperties.index or name;

				if type == "label" then
					--offsets[section] = offsets[section] == 0 and offsets[section] or offsets[section] + 5;
					offset = offsets[section];
					module:create("TextLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, 0, 0, offset),
						Size = udim2(0, 200, 0, 25),
						Font = gothamblack,
						Text = "  " .. name,
						TextColor3 = lightgrey,
						TextSize = 13,
						TextXAlignment = left,
						Parent = parent
					});
					offsets[section] = offsets[section] + 25;
				elseif type == "toggle" then
					local toggle = {};
					toggle.hooks = {callback or function() end};
					module.contents[index] = toggle;

					local togglehitbox = module:create("TextButton", {
						BackgroundTransparency = 1,
						Position = udim2(0, 0, 0, offset),
						Size = udim2(0, 200, 0, 25),
						Font = gotham,
						Text = "            " .. name,
						TextColor3 = lightgrey,
						TextSize = 12,
						TextXAlignment = left,
						Parent = parent
					});

					local togglebackground = module.templates.roundlabel:Clone();
					togglebackground.Position = udim2(0.05, 0, 0.16, 0);
					togglebackground.Size = udim2(0, 16, 0, 16);
					togglebackground.ImageColor3 = lowlightgrey;
					togglebackground.SliceScale = 0.1;
					togglebackground.Parent = togglehitbox;

					local toggleforeground = module.templates.roundlabel:Clone();
					toggleforeground.Position = udim2(0, 1, 0, 1);
					toggleforeground.Size = udim2(0, 14, 0, 14);
					toggleforeground.ImageColor3 = grey;
					toggleforeground.SliceScale = 0.1;
					toggleforeground.Parent = togglebackground;

					local togglecheck = module:create("TextLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, 0, 0, -1),
						Size = udim2(1, 0, 1, 0),
						Font = gothamblack,
						Text = utf8.char(10003),
						TextColor3 = color(0.88627450980392, 0.88627450980392, 0.88627450980392),
						TextSize = 18,
						Parent = toggleforeground
					});

					function toggle:connect(f)
						toggle.hooks[#toggle.hooks + 1] = f;
					end

					function toggle:setvalue(val)
						config[index] = val;
						realcfg[index] = val;
						toggle.value = val;

						if toggle.value then
							toggleforeground.ImageColor3 = blue;
							togglecheck.Visible = true;
						else
							toggleforeground.ImageColor3 = grey;
							togglecheck.Visible = false;
						end

						for i = 1, #toggle.hooks do
							toggle.hooks[i](val);
						end
					end

					function toggle:reset()
						toggle:setvalue(default or false);
					end

					toggle:reset();

					connect(togglehitbox.MouseButton1Click, function()
						toggle:setvalue(not toggle.value);
					end);

					connect(togglehitbox.MouseEnter, function()
						module:tween(togglebackground, 0.15, {
							ImageColor3 = darkblue
						});
					end);

					connect(togglehitbox.MouseLeave, function()
						module:tween(togglebackground, 0.15, {
							ImageColor3 = lowlightgrey
						});
					end);

					offsets[section] = offsets[section] + 25;
					last[section] = "toggle";
					parent.CanvasSize = udim2(0, 0, 0, offsets[section]);

					return toggle;
				elseif type == "textbox" then
					local textbox = {};
					textbox.hooks = {};
					config[index] = default or "";
					realcfg[index] = default or "";
					module.contents[index] = textbox;

					local textlabel = module:create("TextLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, 190, 0, offset),
						Size = udim2(0, 100, 0, 25),
						Font = gotham,
						Text = name,
						TextColor3 = lightgrey,
						TextSize = 12,
						TextXAlignment = left,
						Parent = parent
					});

					local textboxbackground = module.templates.roundlabel:Clone();
					textboxbackground.Position = udim2(0, -180, 0, 4);
					textboxbackground.Size = udim2(0, 172, 0, 16);
					textboxbackground.ImageColor3 = lowlightgrey;
					textboxbackground.SliceScale = 0.1;
					textboxbackground.Parent = textlabel;

					local textboxforeground = module.templates.roundbutton:Clone();
					textboxforeground.Position = udim2(0, 1, 0, 1);
					textboxforeground.Size = udim2(1, -2, 1, -2);
					textboxforeground.ImageColor3 = grey;
					textboxforeground.SliceScale = 0.1;
					textboxforeground.Parent = textboxbackground;

					local textboxselected = module:create("TextBox", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						Text = "",
						TextColor3 = lightgrey,
						TextSize = 12,
						TextTruncate = "AtEnd",
						TextXAlignment = left,
						Parent = textboxforeground
					});

					function textbox:setvalue(val)
						config[index] = val;
						realcfg[index] = val;
						textboxselected.Text = val;
						for i = 1, #textbox.hooks do
							textbox.hooks[i](val);
						end
					end

					function textbox:connect(func)
						textbox.hooks[#textbox.hooks + 1] = func;
					end

					function textbox:reset()
						textbox:setvalue(default or "");
					end

					textbox:reset();

					connect(textboxselected.FocusLost, function()
						textbox:setvalue(textboxselected.Text);
					end);

					connect(textboxselected.MouseEnter, function()
						module:tween(textboxbackground, 0.15, {
							ImageColor3 = darkblue
						});
					end);

					connect(textboxselected.MouseLeave, function()
						module:tween(textboxbackground, 0.15, {
							ImageColor3 = lowlightgrey
						});
					end);

					offsets[section] = offsets[section] + 25;
					last[section] = "dropdown";
					parent.CanvasSize = udim2(0, 0, 0, offsets[section]);

					return textbox;
				elseif type == "slider" then
					local slider = {};
					slider.value = default;
					slider.hooks = {callback or function() end};
					module.contents[index] = slider;

					offsets[section] = offset - (last[section] == "slider" and 5 or (last[section] == "toggle" or last[section] == "dropdown") and 3 or 0);
					offset = offsets[section];

					local sliderlabel = module:create("TextLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, 10, 0, offset),
						Size = udim2(0, 190, 0, 25),
						Font = gotham,
						Text = name,
						TextColor3 = color(0.88627450980392, 0.88627450980392, 0.88627450980392),
						TextSize = 12,
						TextXAlignment = left,
						Parent = parent
					});

					local sliderhitbox = module:create("TextButton", {
						BackgroundTransparency = 1,
						Position = udim2(0, 0, 1, 0),
						Size = udim2(0, 172, 0, 8),
						Text = "",
						Parent = sliderlabel
					});

					local sliderbackground = module.templates.roundlabel:Clone();
					sliderbackground.Size = udim2(0, 172, 0, 8);
					sliderbackground.ImageColor3 = lowlightgrey;
					sliderbackground.SliceScale = 0.1;
					sliderbackground.Parent = sliderhitbox;

					local sliderforeground = module.templates.roundlabel:Clone();
					sliderforeground.Position = udim2(0, 1, 0, 1);
					sliderforeground.Size = udim2(1, -2, 1, -2);
					sliderforeground.ImageColor3 = grey;
					sliderforeground.SliceScale = 0.1;
					sliderforeground.Parent = sliderbackground;

					local sliderfiller = module.templates.roundlabel:Clone();
					sliderfiller.Size = udim2(0, 0, 1, 0);
					sliderfiller.ImageColor3 = blue;
					sliderfiller.SliceScale = 0.1;
					sliderfiller.Parent = sliderforeground;

					local sliderdisplayholder = module.templates.roundlabel:Clone();
					sliderdisplayholder.Position = udim2(1, -47, 0, 7);
					sliderdisplayholder.Size = udim2(0, 29, 0, 12);
					sliderdisplayholder.ImageColor3 = grey;
					sliderdisplayholder.SliceScale = 0.1;
					sliderdisplayholder.Parent = sliderlabel

					local sliderdisplay = module:create("TextBox", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						Text = default or 0,
						TextColor3 = lightgrey,
						TextSize = 10,
						TextTruncate = "AtEnd",
						Parent = sliderdisplayholder
					});

					local diff = max - min;

					function slider:setvalue(val)
						val = math.clamp(val, min, max);

						if additionalproperties.round then
							val = math.floor(val + 0.5);
						end

						slider.value = val;
						config[index] = val;
						realcfg[index] = val;
						sliderdisplay.Text = val;
						sliderfiller:TweenSize(udim2((val - min) / diff, 0, 1, 0), "Out", "Linear", 0.05, true);

						for i = 1, #slider.hooks do
							slider.hooks[i](val);
						end
					end

					local default = default or 0;

					function slider:reset()
						slider:setvalue(default);
					end

					slider:reset();

					function slider:connect(f)
						slider.hooks[#slider.hooks + 1] = f;
					end

					connect(sliderhitbox.MouseButton1Down, function()
						repeat
							local mousepos = v2(mouse.X, mouse.Y);
							local rel = mousepos - sliderforeground.AbsolutePosition;
							rel = math.clamp(rel.X, 0, sliderforeground.AbsoluteSize.X);

							local value = (rel / sliderforeground.AbsoluteSize.X) * diff + min;
							slider:setvalue(tonumber(("%.4s"):format(tostring(value))));

							step:Wait();
						until
							not input.mouse1;
					end);

					connect(sliderdisplay.FocusLost, function()
						slider:setvalue(tonumber(sliderdisplay.Text) or slider.value);
					end);

					connect(sliderhitbox.MouseEnter, function()
						module:tween(sliderbackground, 0.15, {
							ImageColor3 = darkblue
						});
					end);

					connect(sliderhitbox.MouseLeave, function()
						module:tween(sliderbackground, 0.15, {
							ImageColor3 = lowlightgrey
						});
					end);

					offsets[section] = offsets[section] + 40;
					last[section] = "slider";
					parent.CanvasSize = udim2(0, 0, 0, offsets[section]);

					return slider;
				elseif type == "dropdown" then
					local dropdown = {};
					dropdown.selected = default or additionalproperties.entries[1];
					dropdown.showing = false;
					local entries = additionalproperties.entries or {default};
					dropdown.hooks = {callback or function() end};
					module.contents[index] = dropdown;

					local dropdownlabel = module:create("TextLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, 190, 0, offset),
						Size = udim2(0, 100, 0, 25),
						Font = gotham,
						Text = name,
						TextColor3 = lightgrey,
						TextSize = 12,
						TextXAlignment = left,
						Parent = parent
					});

					local dropdownbackground = module.templates.roundlabel:Clone();
					dropdownbackground.Position = udim2(0, -180, 0, 4);
					dropdownbackground.Size = udim2(0, 172, 0, 16);
					dropdownbackground.ImageColor3 = lowlightgrey;
					dropdownbackground.SliceScale = 0.1;
					dropdownbackground.Parent = dropdownlabel;

					local dropdownforeground = module.templates.roundbutton:Clone();
					dropdownforeground.Position = udim2(0, 1, 0, 1);
					dropdownforeground.Size = udim2(1, -2, 1, -2);
					dropdownforeground.ImageColor3 = grey;
					dropdownforeground.SliceScale = 0.1;
					dropdownforeground.Parent = dropdownbackground;

					local dropdownselected = module:create("TextLabel", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						Text = " " .. default,
						TextColor3 = lightgrey,
						TextSize = 12,
						TextXAlignment = left,
						Parent = dropdownforeground
					});

					local dropdownholder = module:create("Frame", {
						BackgroundColor3 = lowlightgrey,
						BorderSizePixel = 0,
						Position = udim2(0, 0, 1, 0),
						Size = udim2(0, 172, 0, 0),
						ClipsDescendants = true,
						ZIndex = 2,
						Parent = dropdownbackground
					});

					local dropoffset = 0;

					function dropdown:setvalue(val)
						dropdownselected.Text = " " .. val;
						dropdown.selected = val;
						config[index] = val;
						realcfg[index] = val;
						
						for i = 1, #dropdown.hooks do
							dropdown.hooks[i](val);
						end
					end

					function dropdown:connect(f)
						dropdown.hooks[#dropdown.hooks + 1] = f;
					end

					function dropdown:update()
						dropoffset = 0;

						dropdownholder:ClearAllChildren();

						for i = 1, #entries do
							local entry = module.templates.roundbutton:Clone();
							entry.Position = udim2(0, 1, 0, dropoffset);
							entry.Size = udim2(1, -2, 0, 14);
							entry.ImageColor3 = grey;
							entry.SliceScale = 0.1;
							entry.ZIndex = 2;
							entry.Parent = dropdownholder;

							dropoffset = dropoffset + 15;

							local entrylabel = module:create("TextLabel", {
								BackgroundTransparency = 1,
								Size = udim2(1, 0, 1, 0),
								ZIndex = 2,
								Font = gotham,
								Text = " " .. entries[i],
								TextColor3 = lightgrey,
								TextSize = 12,
								TextXAlignment = left,
								Parent = entry
							});

							connect(entry.MouseEnter, function()
								module:tween(entrylabel, 0.15, {
									TextColor3 = darkblue
								});
							end);

							connect(entry.MouseLeave, function()
								module:tween(entrylabel, 0.15, {
									TextColor3 = lightgrey
								});
							end);

							connect(entry.MouseButton1Click, function()
								dropdown:setvalue(entries[i])
							end);

							if i == 1 then
								local found = false;
								for i = 1, #entries do
									if entries[i] == default then
										dropdown:setvalue(default);
										found = true;
									end
								end
								if not found then
									dropdown:setvalue(entries[i]);
								end
							end
						end
					end

					dropdown:update();

					function dropdown:add(entry)
						entries[#entries + 1] = entry;
						return dropdown:update();
					end

					function dropdown:remove(entry)
						for i = 1, #entries do
							if entries[i] == entry then
								table.remove(entries, i);
							end
						end

						return dropdown:update();
					end

					function dropdown:fullreplace(array)
						entries = array;
						return dropdown:update();
					end

					function dropdown:clear()
						dropdown:hide();
						entries = {};
						return dropdown:update();
					end

					function dropdown:hide()
						dropdown.showing = false;
						return dropdownholder:TweenSize(udim2(0, 172, 0, 0), "Out", "Linear", 0.01, true);
					end

					function dropdown:show()
						if module.currentdropdown then
							module.currentdropdown:hide();
						end
						module.currentdropdown = dropdown;
						dropdown.showing = true;
						return dropdownholder:TweenSize(udim2(0, 172, 0, dropoffset), "Out", "Linear", 0.01, true);
					end

					connect(dropdownforeground.MouseButton1Click, function()
						if dropdown.showing then
							dropdown:hide();
						else
							dropdown:show();
						end
					end);

					connect(dropdownforeground.MouseEnter, function()
						module:tween(dropdownbackground, 0.15, {
							ImageColor3 = darkblue
						});
					end);

					connect(dropdownforeground.MouseLeave, function()
						module:tween(dropdownbackground, 0.15, {
							ImageColor3 = lowlightgrey
						});
					end);

					offsets[section] = offsets[section] + 25;
					last[section] = "dropdown";
					parent.CanvasSize = udim2(0, 0, 0, offsets[section]);

					return dropdown;
				elseif type == "config" then
					local configsystem = {};
					configsystem.buttons = {};

					local background = module.templates.roundlabel:Clone();
					background.Position = udim2(0, 10, 0, 10);
					background.Size = udim2(1, -20, 0, 210);
					background.ImageColor3 = lowlightgrey;
					background.SliceScale = 0.1;
					background.Parent = category.section2;

					local foreground = module.templates.roundlabel:Clone();
					foreground.Position = udim2(0, 1, 0, 1);
					foreground.Size = udim2(1, -2, 1, -2);
					foreground.ImageColor3 = grey;
					foreground.SliceScale = 0.1;
					foreground.Parent = background;

					local buttoncontainer = module:create("ScrollingFrame", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						CanvasSize = udim2(0, 0, 0, 0),
						ScrollBarImageColor3 = lightgrey,
						ScrollBarThickness = 1,
						Parent = foreground
					});

					local uilist = module:create("UIListLayout", {
						Parent = buttoncontainer
					});

					local template = module:create("TextButton", {
						AutoButtonColor = false,
						BackgroundColor3 = grey,
						BorderSizePixel = 0,
						Size = udim2(1, 0, 0, 15),
						Font = gotham,
						Text = " ",
						TextColor3 = white,
						TextSize = 10,
						TextXAlignment = left
					});

					local template2 = module.templates.roundlabel:Clone();
					template2.ImageColor3 = lowlightgrey;
					template2.SliceScale = 0.1;

					local templatechild = module.templates.roundlabel:Clone();
					templatechild.Position = udim2(0, 1, 0, 1);
					templatechild.Size = udim2(1, -2, 1, -2);
					templatechild.ImageColor3 = grey;
					templatechild.SliceScale = 0.1;
					templatechild.Parent = template2;

					local templatebutton = module:create("TextButton", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						TextColor3 = lightgrey,
						TextSize = 12,
					});

					local function applyeffect(button)
						connect(button.MouseEnter, function()
							module:tween(button.Parent, 0.15, {
								ImageColor3 = darkblue
							})
						end);

						connect(button.MouseLeave, function()
							module:tween(button.Parent, 0.15, {
								ImageColor3 = lowlightgrey
							})
						end);
					end

					local create = template2:Clone();
					create.Position = udim2(0.5, 5, 0, 230);
					create.Size = udim2(0.5, -15, 0, 16);
					create.Parent = category.section2;

					local c_button = templatebutton:Clone()
					c_button.Text = "Create";
					c_button.Parent = create;
					applyeffect(c_button);

					local loadbutton = template2:Clone();
					loadbutton.Position = udim2(0.5, 5, 0, 256);
					loadbutton.Size = udim2(0.5, -15, 0, 16);
					loadbutton.Parent = category.section2;

					local l_button = templatebutton:Clone()
					l_button.Text = "Load";
					l_button.Parent = loadbutton;
					applyeffect(l_button);

					local save = template2:Clone();
					save.Position = udim2(0, 10, 0, 256);
					save.Size = udim2(0.5, -15, 0, 16);
					save.Parent = category.section2;

					local s_button = templatebutton:Clone()
					s_button.Text = "Save";
					s_button.Parent = save;
					applyeffect(s_button);

					local refresh = template2:Clone();
					refresh.Position = udim2(0, 10, 0, 277);
					refresh.Size = udim2(0.5, -15, 0, 16);
					refresh.Parent = category.section2;

					local r_button = templatebutton:Clone()
					r_button.Text = "Refresh";
					r_button.Parent = refresh;
					applyeffect(r_button);

					local defaultbutton = template2:Clone();
					defaultbutton.Position = udim2(0.5, 5, 0, 277);
					defaultbutton.Size = udim2(0.5, -15, 0, 16);
					defaultbutton.Parent = category.section2;

					local d_button = templatebutton:Clone()
					d_button.Text = "Make default";
					d_button.Parent = defaultbutton;
					applyeffect(d_button);

					local namebox = template2:Clone();
					namebox.Position = udim2(0, 10, 0, 230);
					namebox.Size = udim2(0.5, -15, 0, 16);
					namebox.Parent = category.section2;

					local n_box = module:create("TextBox", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						Text = "",
						TextColor3 = lightgrey,
						TextSize = 12,
						TextXAlignment = left,
						Parent = namebox
					});

					applyeffect(n_box);

					local count = 0;

					function configsystem:refresh(entries)
						for _, b in ipairs(buttoncontainer:GetChildren()) do
							if b:IsA("TextButton") then
								b:Remove();
							end
						end

						configsystem.buttons = {};
						count = 0;

						for _, name in pairs(entries) do
							local button = template:Clone();
							button.Text = button.Text .. name;
							button.Parent = buttoncontainer;

							count = count + 1;

							if count == 1 then
								button.BackgroundColor3 = darkgrey;
								configsystem.selected = name;
							end	

							configsystem.buttons[name] = button;

							connect(button.MouseEnter, function()
								module:tween(button, 0.15, {
									TextColor3 = blue
								})
							end);

							connect(button.MouseLeave, function()
								module:tween(button, 0.15, {
									TextColor3 = white
								})
							end);

							connect(button.MouseButton1Click, function()
								local current = configsystem.selected;

								if current ~= name then
									local old = configsystem.buttons[current];
									configsystem.selected = name;

									button.BackgroundColor3 = darkgrey;
									old.BackgroundColor3 = grey;
								end
							end);
						end

						buttoncontainer.CanvasSize = udim2(0, 0, 0, count * 15);
					end

					return configsystem, c_button, l_button, s_button, r_button, d_button, n_box;
				elseif type == "button" then
					offset = offsets[section];
					callback = callback or function() end

					local template2 = module.templates.roundlabel:Clone();
					template2.Position = udim2(0, 0, 0, offset + 5);
					template2.Size = udim2(0, 172, 0, 16);
					template2.ImageColor3 = lowlightgrey;
					template2.SliceScale = 0.1;
					template2.Parent = parent;

					local templatechild = module.templates.roundlabel:Clone();
					templatechild.Position = udim2(0, 1, 0, 1);
					templatechild.Size = udim2(1, -2, 1, -2);
					templatechild.ImageColor3 = grey;
					templatechild.SliceScale = 0.1;
					templatechild.Parent = template2;

					local templatebutton = module:create("TextButton", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						Font = gotham,
						TextColor3 = lightgrey,
						TextSize = 12,
						Text = name,
						Parent = template2
					});

					local function applyeffect(button)
						connect(button.MouseEnter, function()
							module:tween(button.Parent, 0.15, {
								ImageColor3 = darkblue
							})
						end);

						connect(button.MouseLeave, function()
							module:tween(button.Parent, 0.15, {
								ImageColor3 = lowlightgrey
							})
						end);
					end

					applyeffect(templatebutton);

					connect(templatebutton.MouseButton1Click, callback);
					
					offsets[section] = offsets[section] + 25;
					last[section] = "button";
					parent.CanvasSize = udim2(0, 0, 0, offsets[section]);
				elseif type == "colors" then
					local colors = {};
					colors.collection = {};
					colors.buttons = {};
					module.contents.colorpickers = colors;

					local background = module.templates.roundlabel:Clone();
					background.Position = udim2(0, 10, 0, 10);
					background.Size = udim2(1, -20, 0, 210);
					background.ImageColor3 = lowlightgrey;
					background.SliceScale = 0.1;
					background.Parent = category.section1;

					local foreground = module.templates.roundlabel:Clone();
					foreground.Position = udim2(0, 1, 0, 1);
					foreground.Size = udim2(1, -2, 1, -2);
					foreground.ImageColor3 = grey;
					foreground.SliceScale = 0.1;
					foreground.Parent = background;

					local buttoncontainer = module:create("ScrollingFrame", {
						BackgroundTransparency = 1,
						Size = udim2(1, 0, 1, 0),
						CanvasSize = udim2(0, 0, 0, 0),
						ScrollBarImageColor3 = lightgrey,
						ScrollBarThickness = 1,
						Parent = foreground
					});

					local uilist = module:create("UIListLayout", {
						Parent = buttoncontainer
					});

					local template = module:create("TextButton", {
						AutoButtonColor = false,
						BackgroundColor3 = grey,
						BorderSizePixel = 0,
						Size = udim2(1, 0, 0, 15),
						Font = gotham,
						Text = " ",
						TextColor3 = white,
						TextSize = 10,
						TextXAlignment = left
					});

					local colorbox = module:create("ImageButton", {
						AutoButtonColor = false,
						BackgroundColor3 = white,
						BorderSizePixel = 0,
						Position = udim2(0, 10, 0, 10),
						Size = udim2(0, 230, 0, 210),
						ClipsDescendants = true,
						Image = "http://www.roblox.com/asset/?id=4805274903",
						ImageColor3 = white,
						Parent = category.section2
					});

					local colorindicator = module:create("ImageLabel", {
						BackgroundTransparency = 1,
						Position = udim2(0, -7, 0, -7),
						Size = udim2(0, 14, 0, 14),
						Image = "http://www.roblox.com/asset/?id=4675178938",
						ImageColor3 = white,
						Parent = colorbox
					});

					local huebox = module:create("ImageButton", {
						BackgroundTransparency = 1,
						Position = udim2(0, 245, 0, 10),
						Size = udim2(0, 20, 0, 210),
						Image = "http://www.roblox.com/asset/?id=2845339072",
						Parent = category.section2
					});

					local hueindicator = module:create("ImageLabel", {
						BackgroundTransparency = 1,
						Position = udim2(1, 0, 0, 0),
						Size = udim2(0, 6, 0, 10),
						Image = "http://www.roblox.com/asset/?id=5113895567",
						ImageColor3 = color(0.72549019607843, 0.72549019607843, 0.72549019607843),
						Parent = huebox
					});

					connect(colorbox.MouseButton1Down, function()
						coroutine.wrap(function()
							local size = colorbox.AbsoluteSize;
							local pos = colorbox.AbsolutePosition;

							repeat
								local mousepos = v2(mouse.X, mouse.Y);
								local relpos = mousepos - pos;

								local x, y = math.clamp(relpos.X, 0, size.X), math.clamp(relpos.Y, 0, size.Y);

								colorindicator.Position = udim2(0, x - 7, 0, y - 7);

								if colors.selected then
									local h = Color3.toHSV(colors.collection[colors.selected]);

									colors:displaycolor(colors.selected, Color3.fromHSV(h, math.clamp((colorindicator.Position.X.Offset + 7) / colorbox.AbsoluteSize.X, 0, 1), math.clamp(1 - (colorindicator.Position.Y.Offset + 7) / colorbox.AbsoluteSize.Y, 0, 1)), "sat");
								end

								step:Wait();
							until
								not input.mouse1;
						end)();
					end);

					connect(huebox.MouseButton1Down, function()
						coroutine.wrap(function()
							local size = huebox.AbsoluteSize;
							local posy = huebox.AbsolutePosition.Y;

							repeat
								local mouseposy = mouse.Y;
								local relpos = mouseposy - posy;

								local y = math.clamp(relpos, 0, size.Y);

								hueindicator.Position = udim2(1, 0, 0, y - 5);

								if colors.selected then
									local _, s, v = Color3.toHSV(colors.collection[colors.selected]);
									local newhue = math.clamp(1 - (hueindicator.Position.Y.Offset + 5) / huebox.AbsoluteSize.Y, 0, 1);

									colors:displaycolor(colors.selected, Color3.fromHSV(newhue, s, v), "hue");
								end

								step:Wait();
							until
								not input.mouse1;
						end)();
					end);

					colors.hooks = {};

					function colors:displaycolor(name, color, additional)
						config[name] = color;
						colors.collection[name] = color;
						local modifiedname = name:lower():gsub(" ",""):gsub("%(",""):gsub("%)",""):gsub("%.",""):gsub("%,",""):gsub("%[",""):gsub("%]","");
						realcfg[modifiedname] = color;

						local h, s, v = Color3.toHSV(color);

						if additional == "hue" then
							--hueindicator.Position = udim2(1, 0, 0, (1 - h) * huebox.AbsoluteSize.Y - 5);
							colorbox.BackgroundColor3 = Color3.fromHSV(h, 1, 1);
						elseif additional == "sat" then
							--colorindicator.Position = udim2(0, s * colorbox.AbsoluteSize.X - 7, 0, (1 - v) * colorbox.AbsoluteSize.Y - 7);
						else
							hueindicator.Position = udim2(1, 0, 0, (1 - h) * huebox.AbsoluteSize.Y - 5);
							colorbox.BackgroundColor3 = Color3.fromHSV(h, 1, 1);
							colorindicator.Position = udim2(0, s * colorbox.AbsoluteSize.X - 7, 0, (1 - v) * colorbox.AbsoluteSize.Y - 7);
						end

						if colors.hooks[name] then
							colors.hooks[name](color);
						end
					end

					function colors:connect(name, func)
						colors.hooks[name] = func;
					end

					local count = 0;

					function colors:refresh(entries)
						for _, b in ipairs(buttoncontainer:GetChildren()) do
							if b:IsA("TextButton") then
								b:Remove();
							end
						end

						colors.collection = {};
						colors.buttons = {};
						count = 0;

						for name, col in pairs(entries) do

							local button = template:Clone();
							button.Text = button.Text .. name;
							button.Parent = buttoncontainer;

							count = count + 1;

							local default = col;

							if count == 1 then
								button.BackgroundColor3 = darkgrey;
								colors.selected = name;
								colors:displaycolor(name, default);
							end	

							colors.collection[name] = default;
							colors.buttons[name] = button;
							config[name] = default;
							local modifiedname = name:lower():gsub(" ",""):gsub("%(",""):gsub("%)",""):gsub("%.",""):gsub("%,","");
							realcfg[modifiedname] = default;

							connect(button.MouseEnter, function()
								module:tween(button, 0.15, {
									TextColor3 = blue
								})
							end);

							connect(button.MouseLeave, function()
								module:tween(button, 0.15, {
									TextColor3 = white
								})
							end);

							connect(button.MouseButton1Click, function()
								local current = colors.selected;

								if current ~= name then
									local old = colors.buttons[current];
									colors.selected = name;

									colors:displaycolor(name, colors.collection[name]);

									button.BackgroundColor3 = darkgrey;
									old.BackgroundColor3 = grey;
								end
							end);
						end
					end

					return colors;
				end

				return;
			end

			-- connections

			connect(category.button.MouseButton1Click, function()
				if name ~= window.curcategory then
					local old = window.categories[window.curcategory];
					window.curcategory = name;

					old.main.Visible = false;
					module:tween(old.buttonlabel, 0.15, {
						TextColor3 = lightgrey
					});

					category.main.Visible = true;
					category.buttonlabel.TextColor3 = blue;

					if module.currentdropdown then
						module.currentdropdown:hide();
					end
				end
			end);

			connect(category.button.MouseEnter, function()
				module:tween(category.buttonlabel, 0.15, {
					TextColor3 = blue
				});
			end);

			connect(category.button.MouseLeave, function()
				if name ~= window.curcategory then
					module:tween(category.buttonlabel, 0.15, {
						TextColor3 = lightgrey
					});
				end
			end);

			-- other

			window.categories[name] = category;
			window.categorycount = window.categorycount + 1;

			if window.categorycount == 1 then
				category.main.Visible = true;
				category.buttonlabel.TextColor3 = blue;
				window.curcategory = name;
			end

			return category;
		end

		-- done!

		return window;
	end
end

return module, realcfg;
