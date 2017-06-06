
1.skynet API  https://github.com/cloudwu/skynet/wiki/APIList

2.关于因阻塞导致的消息处理顺序问题  https://github.com/cloudwu/skynet/wiki/CriticalSection

3.使用gateServer的话 每个包就是 2 个字节 + 数据内容。这两个字节是 Big-Endian 编码的一个数字。数据内容可以是任意字节。
所以，单个数据包最长不能超过 65535 字节。如果业务层需要传输更大的数据块，请在上层业务协议中解决。

4.
在 skynet 中，用服务 (service) 这个概念来表达某项具体业务，它包括了处理业务的逻辑以及关联的数据状态。对，使用 skynet 实现游戏服务器时，不建议把业务状态同步到数据库中，而是存放在服务的内存数据结构里。服务、连同服务处理业务的逻辑代码和业务关联的状态数据，都是常驻内存的。如果数据库是你架构的一部分，那么大多数情况下，它扮演的是一个数据备份的角色。你可以在状态改变时，把数据推到数据库保存，也可以定期写到数据库备份。业务处理时直接使用服务内的内存数据结构。

5.
和 erlang 不同，一个 skynet 服务在某个业务流程被挂起后，即使回应消息尚未收到，它还是可以处理其他的消息的。所以同一个 skynet 服务可以同时拥有多条业务执行线。所以，你尽可以让同一个 skynet 服务处理很多消息，它们会看起来并行，和真正分拆到不同的服务中处理的区别是，这些处理流程永远不会真正的并行，它们只是在轮流工作。一段业务会一直运行到下一个 IO 阻塞点，然后切换到下一段逻辑。你可以利用这一点，让多条业务线在处理时共享同一组数据，这些数据在同一个 lua 虚拟机下时，读写起来都比通过消息交换要廉价的多。

6.
如果一条用户线程永远不调用阻塞 API 让出控制权，那么它将永远占据系统工作线程。skynet 并不是一个抢占式调度器，没有时间片的设计，不会因为一个工作线工作时间过长而强制挂起它。所以需要开发者自己小心，不要陷入死循环。不过，skynet 框架也做了一些监控工作，会在某个服务内的某个工作线程占据了太长时间后，以 log 的形式报告

7.
以 . 开头的名字是在同一 skynet 节点下有效的，跨节点的 skynet 服务对别的节点下的 . 开头的名字不可见。不同的 skynet 节点可以定义相同的 . 开头的名字。

8. https://github.com/cloudwu/skynet/wiki/Cluster
可以通过 cluster.call(nodename, service, ...) 提起请求。这里 nodename 就是在配置表中给出的节点名。service 可以是一个字符串，或者直接是一个数字地址（如果你能从其它渠道获得地址的话）。当 service 是一个字符串时，只需要是那个节点可以见到的服务别名，可以是全局名或本地名。但更推荐是 . 开头的本地名