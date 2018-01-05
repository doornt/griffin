import { ETaskType, ITaskEvent } from "../Interface/Task";
export declare class TaskManager {
    private static $inst;
    private constructor();
    static readonly instance: TaskManager;
    init(): void;
    send(type: ETaskType, e: ITaskEvent): void;
    private $sendView(e);
    private $createView(selfId, attr);
    private $createText(selfId, attr);
    private $addChild(parentId, childAttr);
    private $addSubview(parentId, childId);
    private $createRoot(nodeId);
}
