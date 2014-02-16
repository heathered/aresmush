require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe EmitCmd do
      include CommandTestHelper
      
      before do
        init_handler(EmitCmd, "emit")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command? do
        it "should not want another command" do
          cmd.stub(:root_is?).with("emit") { false }
          handler.want_command?(client, cmd).should eq false
        end

        it "should want the emit command" do
          handler.want_command?(client, cmd).should eq true
        end
      end
      
      describe :validate do
        it "should reject the command if a switch is specified" do
          cmd.stub(:switch) { "sw" }
          client.stub(:logged_in?) { true }
          handler.validate.should eq 'pose.invalid_pose_syntax'
        end

        it "should reject the command if not logged in" do
          client.stub(:logged_in?) { false }
          cmd.stub(:switch) { nil }
          handler.validate.should eq 'dispatcher.must_be_logged_in'
        end

        it "should accept the command otherwise" do
          client.stub(:logged_in?) { true }
          cmd.stub(:switch) { nil }
          handler.validate.should eq nil
        end
      end
        
      describe :handle do
        it "should emit to the room" do
          room = double
          client.stub(:room) { room }
          client.stub(:name) { "name" }
          cmd.stub(:args) { "test emit" }
          room.should_receive(:emit).with("test emit")
          handler.handle
        end
      end

    end
  end
end