package com.benchmark;

import net.minecraft.client.Minecraft;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.event.entity.EntityJoinLevelEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.loading.FMLPaths;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

@Mod("fpsbenchmark")
public class FpsBenchmarkMod {
    private static boolean running = false;
    private static int ticks = 0;
    private static final int LOAD_TICKS = 100;
    private static final int SPIN_TICKS = 600;
    private static final int TOTAL_TICKS = LOAD_TICKS + SPIN_TICKS;
    private static final List<String> fpsData = new ArrayList<>();

    public FpsBenchmarkMod() {
        MinecraftForge.EVENT_BUS.register(this);
    }

    @SubscribeEvent
    public void onEntityJoin(EntityJoinLevelEvent event) {
        if (running) return;
        if (!(event.getEntity() instanceof net.minecraft.client.player.LocalPlayer)) return;
        running = true;
        ticks = 0;
        fpsData.clear();
        fpsData.add("second,fps,free_mb,total_mb");
    }

    @SubscribeEvent
    public void onClientTick(TickEvent.ClientTickEvent event) {
        if (!running) return;
        if (event.phase != TickEvent.Phase.END) return;

        Minecraft mc = Minecraft.getInstance();
        if (mc.player == null || mc.level == null) return;

        ticks++;

        if (ticks % 20 == 0) {
            int fps = mc.fps;
            long freeMem = Runtime.getRuntime().freeMemory() / 1048576L;
            long totalMem = Runtime.getRuntime().totalMemory() / 1048576L;
            fpsData.add(String.format("%d,%d,%d,%d", ticks / 20, fps, freeMem, totalMem));
        }

        if (ticks > LOAD_TICKS) {
            float rotPerTick = 360.0f / SPIN_TICKS;
            mc.player.setYRot(mc.player.getYRot() + rotPerTick);
        }

        if (ticks >= TOTAL_TICKS) {
            running = false;
            Path out = FMLPaths.GAMEDIR.get().resolve("fps_log.csv");
            try {
                Files.write(out, fpsData);
                System.out.println("[Benchmark] Saved to " + out);
            } catch (IOException e) {
                e.printStackTrace();
            }
            mc.stop();
        }
    }
}
