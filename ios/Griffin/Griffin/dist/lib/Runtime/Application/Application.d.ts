import { BaseComponent } from "../../gn";
export declare class Application {
    private static $inst;
    private $root;
    private constructor();
    static readonly instance: any;
    static readonly env: any;
    init(): void;
    runWithModule(view: BaseComponent): void;
}
