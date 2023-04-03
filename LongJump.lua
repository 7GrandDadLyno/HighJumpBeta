--\\ Variables //--
repeat task.wait() until game.Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService('RunService')

local Character = game.Players.LocalPlayer.Character
local JumpAnimation = Character.Humanoid:LoadAnimation(RS.LongJumpAnimation.LongJumps)
local DView = 70
local Table = {}

local root = script.Parent.PrimaryPart
local humanoid = root.Parent:WaitForChild("Humanoid")
local state = " "

local stateText = script.Parent:WaitForChild("Head"):FindFirstChildOfClass("BillboardGui").TextLabel

local Animator = humanoid:WaitForChild("Animator")

--\\ Animations //--
local runAnimId = Instance.new("Animation")
runAnimId.AnimationId = "rbxassetid://10493878394"

local walkAnimId = Instance.new("Animation")
walkAnimId.AnimationId = "rbxassetid://10494088845"

local jumpAnimId = Instance.new("Animation")
jumpAnimId.AnimationId = "rbxassetid://10494212955"

local fallAnimId = Instance.new("Animation")
fallAnimId.AnimationId = "rbxassetid://10494451597"

local runAnim = Animator:LoadAnimation(runAnimId)
local walkAnim = Animator:LoadAnimation(walkAnimId)
local jumpAnim = Animator:LoadAnimation(jumpAnimId)
local fallAnim = Animator:LoadAnimation(fallAnimId)


--\\ Functions //--

function speedWatch(speed)
	if speed == 32 then
		local boostVal = 1.25
		return boostVal
	elseif speed == 16 then
		local boostVal = 1.15
		return boostVal
	else
		local boostVal = 1
		return boostVal
	end
end

local function StateCheck()
	local current = humanoid:GetState()
	if current == Enum.HumanoidStateType.Running and humanoid.MoveDirection.Magnitude > 0 then
		local Speed = humanoid.WalkSpeed
		if Speed > .75 and Speed < 32 then
			state = "WALKING"
			if runAnim.IsPlaying then
				runAnim:Stop()
			end
			if not walkAnim.IsPlaying then
				walkAnim:Play()
			end
			if jumpAnim.IsPlaying then
				jumpAnim:Stop()
			end
			if fallAnim.IsPlaying then
				fallAnim:Stop()
			end
		elseif Speed >= 32 then
			state = "RUNNING"
			if not runAnim.IsPlaying then
				runAnim:Play()
			end
			if walkAnim.IsPlaying then
				walkAnim:Stop()
			end
			if jumpAnim.IsPlaying then
				jumpAnim:Stop()
			end
			if fallAnim.IsPlaying then
				fallAnim:Stop()
			end
		end
	elseif current == Enum.HumanoidStateType.Jumping then
		state = "JUMPING"
		if runAnim.IsPlaying then
			runAnim:Stop()
		end
		if walkAnim.IsPlaying then
			walkAnim:Stop()
		end
		if fallAnim.IsPlaying then
			fallAnim:Stop()
		end
		if not jumpAnim.IsPlaying then
			jumpAnim:Play()
		end
	elseif current == Enum.HumanoidStateType.Freefall then
		state = "FREEFALL"
		if runAnim.IsPlaying then
			runAnim:Stop()
		end
		if walkAnim.IsPlaying then
			walkAnim:Stop()
		end
		if jumpAnim.IsPlaying then
			jumpAnim:Stop()
		end
		if not fallAnim.IsPlaying then
			fallAnim:Play()
		end
	else
		state = "IDLE"
		humanoid.WalkSpeed = 16
		if runAnim.IsPlaying then
			runAnim:Stop()
		end
		if walkAnim.IsPlaying then
			walkAnim:Stop()
		end
		if jumpAnim.IsPlaying then
			jumpAnim:Stop()
		end
		if fallAnim.IsPlaying then
			fallAnim:Stop()
		end
	end
	print(state)
end

local Deb = false

UIS.InputBegan:Connect(function(Input, IsTyping)
	print(state == "RUNNING" and state ~= "IDLE" and state ~= "JUMPING" and state ~= "LONG_JUMP")
	if state == "RUNNING" and state ~= "IDLE" and state ~= "JUMPING" and state ~= "LONG_JUMP" and state ~= "FREEFALL" then
		if IsTyping then return end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) and UIS:IsKeyDown(Enum.KeyCode.Space) and humanoid.Running then
			if not Deb then
				Deb = true
				
				for i = 1,20 do
					task.spawn(function()
						task.wait(.0075)
						state = "LONG_JUMP"
					end)
				end
				local speed = Character.Humanoid.WalkSpeed

				local speedBoost = speedWatch(humanoid.WalkSpeed)

				JumpAnimation:Play()

				humanoid.Jump = false humanoid.JumpPower = 0
				root:ApplyImpulse(root.CFrame.LookVector * (1000 * speedBoost))
				workspace.Gravity = 145.8
				root:ApplyImpulse(root.CFrame.YVector * (475 * speedBoost))
				task.wait(0.25)
				workspace.Gravity = 196.2
				humanoid.Jump = false humanoid.JumpPower = 50

				JumpAnimation:Stop()

				Deb = false
			end
		end
	end
end)

RunService.Heartbeat:Connect(StateCheck)

--\\ Loops //--

while task.wait() do
	stateText.Text = "STATE: "..state
	print(state)
end
