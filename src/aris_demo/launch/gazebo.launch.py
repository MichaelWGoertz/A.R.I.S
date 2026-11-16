import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription, SetEnvironmentVariable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import Command
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue


def generate_launch_description():
    pkg_share = get_package_share_directory('aris_demo')
    urdf_file = os.path.join(pkg_share, 'urdf', 'robot.urdf.xacro')

    # Lets Gazebo Harmonic resolve package://aris_demo/... paths (like meshes)
    gz_resource_path = SetEnvironmentVariable(
        name='GZ_SIM_RESOURCE_PATH',
        value=os.path.dirname(pkg_share)
    )

    # Process the URDF/Xacro file into an XML string
    robot_description = ParameterValue(
        Command(['xacro ', urdf_file]),
        value_type=str
    )

    # Publish the robot model and TF transforms to /robot_description
    robot_state_publisher = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[{'robot_description': robot_description}],
        output='screen'
    )

    # Launch Gazebo Harmonic with an empty world (-r starts simulation immediately)
    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(
                get_package_share_directory('ros_gz_sim'),
                'launch',
                'gz_sim.launch.py'
            )
        ),
        launch_arguments={'gz_args': 'empty.sdf -r'}.items()
    )

    # Spawn the robot from /robot_description into Gazebo
    spawn_robot = Node(
        package='ros_gz_sim',
        executable='create',
        arguments=[
            '-topic', 'robot_description',
            '-name', 'aris_robot',
            '-z', '0.5'
        ],
        output='screen'
    )

    # Bridge /cmd_vel (ROS -> Gazebo) and /odom (Gazebo -> ROS)
    bridge = Node(
        package='ros_gz_bridge',
        executable='parameter_bridge',
        arguments=[
            '/cmd_vel@geometry_msgs/msg/Twist]gz.msgs.Twist',
            '/odom@nav_msgs/msg/Odometry[gz.msgs.Odometry',
        ],
        output='screen'
    )

    return LaunchDescription([
        gz_resource_path,
        robot_state_publisher,
        gazebo,
        spawn_robot,
	bridge,
    ])
