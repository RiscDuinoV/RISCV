package vexriscv

import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}
import spinal.core._
import spinal.lib._
import spinal.lib.com.jtag.Jtag

object GenVexRiscv
{
    def config(withMulDiv : Boolean, barrielShifter : Boolean, withDebug : Boolean) =
    {
        val plugins = List(
            new IBusSimplePlugin(
                resetVector = 0x00000000l,
                cmdForkOnSecondStage = false,
                cmdForkPersistence = true,
                prediction = NONE,
                catchAccessFault = false,
                compressedGen = false
            ),
            new DBusSimplePlugin(
                catchAddressMisaligned = false,
                catchAccessFault = false
            ),
            new CsrPlugin(CsrPluginConfig.all(0x00000000l)),
            new DecoderSimplePlugin(
                catchIllegalInstruction = false
            ),
            new RegFilePlugin(
                regFileReadyKind = plugin.SYNC,
                zeroBoot = false
            ),
            new IntAluPlugin,
            new SrcPlugin(
                separatedAddSub = false,
                executeInsertion = false
            ),
            new HazardSimplePlugin(
                bypassExecute           = false,
                bypassMemory            = false,
                bypassWriteBack         = false,
                bypassWriteBackBuffer   = false,
                pessimisticUseSrc       = false,
                pessimisticWriteRegFile = false,
                pessimisticAddressMatch = false
            ),
            new BranchPlugin(
                earlyBranch = false,
                catchAddressMisaligned = false
            )
        ) ++ (if (!withDebug) Nil else List(
            new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset")))
        )) ++ (if (!withMulDiv) Nil else List(
            new MulPlugin,
            new DivPlugin
        )) ++ List(if (!barrielShifter)
            new LightShifterPlugin
        else
            new FullBarrelShifterPlugin(
                earlyInjection = false
            )
        )
        plugins
    }
    def main(args: Array[String])
    {
        SpinalConfig(
            mode = Verilog,
            defaultConfigForClockDomains = ClockDomainConfig.apply(resetKind = spinal.core.SYNC),
            onlyStdLogicVectorAtTopLevelIo = true,
            targetDirectory = "../cpu"
        ).generate{
            val cpuConfig = VexRiscvConfig(config(withMulDiv = false, barrielShifter = false, withDebug = true))
            val cpu = new VexRiscv(config = cpuConfig)
            cpu.rework{
                for (plugin <- cpuConfig.plugins) plugin match {
                    case plugin: DebugPlugin => plugin.debugClockDomain {
                        plugin.io.bus.setAsDirectionLess()
                        val jtag = slave(new Jtag())
                            .setName("jtag")
                        jtag <> plugin.io.bus.fromJtag()
                    }
                    case _ =>
                }
            }
            cpu
        }
    }
}
class JtagDebug() extends Component
{
    val io = new Bundle
    {
        val jtag = slave(Jtag())
        val debugExtensionBus = master(DebugExtensionBus())
    }
    io.jtag.setName("jtag")
    io.debugExtensionBus.setName("debug_bus")
    io.jtag <>  io.debugExtensionBus.fromJtag()
}
object GenJtag
{
    def main(args: Array[String]): Unit =
    {
        SpinalConfig(
            mode = VHDL,
            onlyStdLogicVectorAtTopLevelIo = true
        ).generate(new JtagDebug)
    }
}