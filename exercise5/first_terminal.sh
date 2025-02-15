source /opt/ros/humble/setup.bash
rosdep install --from-paths ./ --ignore-src -r -y
colcon build --symlink-install
source /opt/ros/humble/setup.bash
source install/setup.bash
ros2 launch plansys2_exercise5 plansys2_exercise5_launch.py
