export declare enum ETaskType {
    VIEW = "view",
    ROOT = "create_root",
}
export declare enum EViewTask {
    CREATE_VIEW = "create_view",
    CREATE_LABEL = "create_label",
    SET_ROOT = "set_root",
    ADD_CHILD = "add_child",
    ADD_SUBVIEW = "add_subview",
}
export interface ITaskEvent {
    action: EViewTask;
    parentId: string;
    nodeId: string;
    data: any;
}
