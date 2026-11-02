import rclpy
from rclpy.node import Node


class HelloRobot(Node):

    def __init__(self):
        super().__init__('hello_robot')

        self.timer = self.create_timer(1.0, self.timer_callback)

        self.get_logger().info('A.R.I.S. robot node started!')

    def timer_callback(self):
        self.get_logger().info('Robot software is running!')


def main(args=None):
    rclpy.init(args=args)

    node = HelloRobot()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()