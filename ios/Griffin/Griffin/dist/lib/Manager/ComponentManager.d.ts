import { IPugAttr } from "../Interface/INode";
export declare class ComponentManager {
    private static $inst;
    private _registeredClass;
    private constructor();
    static readonly instance: ComponentManager;
    register(name: string, ctr: object): void;
    createViewByTag(tag: string, attrs: Array<IPugAttr>, styles: any): any;
}
